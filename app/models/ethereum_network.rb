# eth to ebc logic
class EthereumNetwork
  # get etherscan query tx list api
  def api(page: 1, offset: 20, startblock: nil, endblock: nil)
    host = ENV.fetch("ETHERSCAN_API_URL")
    params = {
      module: "account",
      action: "txlist",
      address: ENV.fetch("ACCOUNT_ADDRESS"),
      sort: :desc,
      page: page,
      offset: offset,
      startblock: startblock,
      endblock: endblock,
      apikey: ENV.fetch("ETHERSCAN_API_TOKEN")
    }

    params_str = params.reject { |_k, v| v == nil }.map { |k, v| "#{k}=#{v}" }.join("&")

    "#{host}?#{params_str}"
  end

  # get transactions from etherscan
  def result(page: 1, offset: 20, startblock: nil, endblock: nil)
    conn = Faraday.new(url: api(page: page, offset: offset, startblock: startblock, endblock: endblock)) do |faraday|
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

  # listen transactions from etherscan
  def listen_transactions(page = 1)
    transactions, is_empty = to_txs(page)
    return if is_empty

    transactions.each do |tx|
      eth_tx_hash = tx["hash"]
      flag = EthToEbc.exists?(eth_tx_hash: eth_tx_hash)
      return if flag
      EthToEbc.create({
                        address: tx["from"],
                        eth_block_num: tx["blockNumber"],
                        eth_block_timestamp: tx["timeStamp"],
                        eth_tx_hash: eth_tx_hash,
                        value: tx["value"],
                      })
    end

    listen_transactions(page + 1)
  end

  # get transactions whose "to" is us
  def to_txs(page = 1)
    account_address = ENV.fetch("ACCOUNT_ADDRESS")
    txs = result(page: page)
    [txs.select { |tx| same_address?(tx["to"], account_address) }, txs.empty?]
  end

  # process transactions who's confirmed over 30 blocks
  def process_transfers
    web3 = self.class.new_web3
    eth_current_block_num = web3.eth.blockNumber
    eth_to_ebcs = EthToEbc.started.where("eth_block_num <= ?", eth_current_block_num - 30)
    eth_to_ebcs.each do |e2e|
      # transfer(e2e.eth_tx_hash)
      EthToEbcTransferJob.perform_later(e2e.eth_tx_hash)
    end
  end

  # transfer to account
  def transfer(eth_tx_hash)
    tx = EthToEbc.find_by(eth_tx_hash: eth_tx_hash)
    return if tx.nil?
    return unless tx.ac_tx_hash.nil?

    tx.with_lock do
      user_address = tx.address
      # decimal value
      value = tx.value.to_i
      appchain_url = ENV.fetch("APPCHAIN_URL")

      private_key = ENV.fetch("ACCOUNT_PRIVATE_KEY")

      napp = NApp::Client.new(appchain_url)
      abi = File.read(Rails.root.join("lib/ebc_abi.json"))

      contract_address = ENV.fetch("CONTRACT_ADDRESS")
      contract = napp.contract_at(abi, contract_address)
      valid_until_block = napp.rpc.block_number["result"].hex + 88
      napp_transaction = NApp::Transaction.new(nonce: SecureRandom.hex, valid_until_block: valid_until_block, chain_id: ENV.fetch("APPCHAIN_CHAIN_ID").to_i, to: contract_address)
      contract_resp = contract.send_func(tx: napp_transaction, private_key: private_key, method: "mint", params: [user_address, value, tx.eth_tx_hash])
      tx.update(ac_tx_hash: contract_resp["hash"], ac_tx_at: Time.now, status: :pending)
    end
  end

  # need polling
  def process_update_tx
    # find all pending transactions, those need to update status
    transactions = EthToEbc.where(status: :pending)
    transactions.each do |tx|
      # replace with sidekiq
      # update_tx(tx.eth_tx_hash)
      EthToEbcUpdateTxJob.perform_later(tx.eth_tx_hash)
    end
  end

  # 异步调用，在 transfer 结束后开始查询
  def update_tx(eth_tx_hash)
    tx = EthToEbc.find_by(eth_tx_hash: eth_tx_hash)
    return if tx.nil?
    return unless tx.pending?

    tx.with_lock do
      rebirth_api_url = ENV.fetch("REBIRTH_API_URL")
      conn = Faraday.new(url: rebirth_api_url) do |faraday|
        faraday.headers["Content-Type"] = "application/json"
        faraday.request :url_encoded # form-encode POST params
        # faraday.response :logger                  # log requests to $stdout
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end
      transaction = Oj.load(conn.get(tx.ac_tx_hash).body).dig("result", "transaction")

      # return if transaction is nil, will query later
      return if transaction.nil?

      tx.update({
                  ac_block_num: transaction["blockNumber"].hex,
                  ac_block_timestamp: transaction["timestamp"],
                  status: transaction["errorMessage"].nil? ? :completed : :failed
                })
    end
  end

  def self.new_web3
    infura_url = ENV.fetch("INFURA_URL")
    uri = URI.parse(infura_url)
    Web3::Eth::Rpc.new host: uri.host, port: uri.port, connect_options: { use_ssl: uri.scheme == "https" ? true : false, rpc_path: uri.path }
  end
end
