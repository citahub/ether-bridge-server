class EbcToEthTransferJob < ApplicationJob
  queue_as :ebc_to_eth_transfers

  def perform(wd_tx_hash)
    AppChainNetwork.new.transfer(wd_tx_hash)
  end
end
