class EbcToEthTransferJob < ApplicationJob
  queue_as :ebc_to_eth_transfers

  retry_on StandardError, wait: 20.seconds, attempts: 10

  def perform(wd_tx_hash)
    AppChainNetwork.new.transfer(wd_tx_hash)
  end
end
