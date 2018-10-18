class AppChainNetwork
  # keccak256("Withdraw(uint64,uint256,address)")
  WITHDRAW_SIGNATURE = "0xbac718d989bd5e076dc97965980684101cba7f64814ba93dd38abf61b6699961"

  # rebirth event logs api
  def api(page: 1, per_page: 20)
    host = "#{ENV.fetch("REBIRTH_EVENT_LOG_API_URL")}/#{ENV.fetch("CONTRACT_ADDRESS")}"
    params = {
      page: page,
      perPage: per_page
    }

    params_str = params.reject { |_k, v| v.nil? }.map { |k, v| "#{k}=#{v}" }.join("&")
    "#{host}?#{params_str}"
  end

  # get event logs from rebirth
  def result(page: 1, per_page: 20)
    conn = Faraday.new(url: api(page: page, per_page: per_page)) do |faraday|
      faraday.headers["Content-Type"] = "application/json"
      faraday.request :url_encoded # form-encode POST params
      # faraday.response :logger                  # log requests to $stdout
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end

    Oj.load(conn.get.body)["result"]
  end

  # compare two address is same ?
  # @return [true | false]
  def same_address?(addr1, addr2)
    addr_1 = NApp::Utils.remove_hex_prefix(addr1)
    addr_2 = NApp::Utils.remove_hex_prefix(addr2)
    addr_1.casecmp?(addr_2)
  end

  def withdraw_events(page = 1)
    event_logs = result(page: page)["eventLogs"]
    [event_logs.select { |e| e["topics"]&.include?(WITHDRAW_SIGNATURE) }, event_logs.empty?]
  end

  def listen_event_logs(page = 1)
    event_logs, is_empty = withdraw_events(page)
    return if is_empty

    appchain_url = ENV.fetch("APPCHAIN_URL")
    napp = NApp::Client.new(appchain_url)

    event_logs.each do |el|
      wd_tx_hash = el["transactionHash"]
      flag = EbcToEth.exists?(wd_tx_hash: wd_tx_hash)
      return if flag

      pel = parse_event_log(el)
      timestamp = napp.rpc.get_block_by_number(el["blockNumber"], false).dig("result", "header", "timestamp")
      EbcToEth.create({
                        address: pel[:addr],
                        wdid: pel[:wdid],
                        value: pel[:token].to_s,
                        initialized_timestamp: timestamp,
                        wd_block_num: el["blockNumber"],
                        wd_tx_hash: wd_tx_hash
                      })
    end

    listen_event_logs(page + 1)
  end

  def parse_event_log(event_log)
    web3 = EthereumNetwork.new_web3
    abi = File.read(Rails.root.join("lib/ebc_abi.json"))
    my_contract = web3.eth.contract(abi)
    log = Web3::Eth::Log.new(event_log)
    params = my_contract.parse_log_args log
    param_names = [:wdid, :token, :addr]
    hash = Hash[param_names.zip(params)]
    hash[:addr] = NApp::Utils.add_hex_prefix(hash[:addr])
    hash
  end

  def process_transfers
    # return if EbcToEth.exists?(status: :pending)
    #
    # ebc_to_eth = EbcToEth.started.first
    # return if ebc_to_eth.nil?
    ebc_to_eths = EbcToEth.started
    ebc_to_eths.find_each do |e2e|
      EbcToEthTransferJob.perform_later(e2e.wd_tx_hash)
    end
  end

  def transfer(wd_tx_hash)
    tx = EbcToEth.find_by(wd_tx_hash: wd_tx_hash)
    return if tx.nil?
    return unless tx.started?

    tx.with_lock do
      private_key = ENV.fetch("ACCOUNT_PRIVATE_KEY")
      pk = NApp::Utils.remove_hex_prefix(private_key)
      key = Eth::Key.new priv: pk
      infura_url = ENV.fetch("INFURA_URL")
      client = Ethereum::HttpClient.new(infura_url)
      eth_tx_hash = client.transfer(key, tx.address, tx.value.to_i)
      tx.update(eth_tx_hash: eth_tx_hash, status: :pending)
    end
  end

  def process_update_tx
    ebc_to_eths = EbcToEth.where(status: :pending)
    ebc_to_eths.find_each do |e2e|
      EbcToEthUpdateTxJob.perform_later(e2e.wd_tx_hash)
    end
  end

  # get eth_block_num eth_tx_timestamp
  def update_tx(wd_tx_hash)
    tx = EbcToEth.find_by(wd_tx_hash: wd_tx_hash)
    return if tx.nil?

    tx.with_lock do
      return unless tx.pending?
      eth_tx_hash = tx.eth_tx_hash
      web3 = EthereumNetwork.new_web3
      transaction = web3.eth.getTransactionByHash eth_tx_hash
      transaction_receipt = web3.eth.getTransactionReceipt eth_tx_hash
      block_number = transaction.blockNumber.hex
      block = web3.eth.getBlockByNumber block_number
      status = transaction_receipt.status.hex == 1 ? :completed : :failed
      tx.update(eth_block_num: block_number, eth_tx_timestamp: block.timestamp.hex.to_s, status: status)
    end
  end

  # 30 blocks confirmed
  def confirm_tx
    web3 = EthereumNetwork.new_web3
    eth_current_block_num = web3.eth.blockNumber
    EbcToEth.completed.where("eth_block_num <= ?", eth_current_block_num - 30).update_all(status: :success)
  end

end
