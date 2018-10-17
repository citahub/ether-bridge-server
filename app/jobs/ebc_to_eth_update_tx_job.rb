class EbcToEthUpdateTxJob < ApplicationJob
  queue_as :ebc_to_eth_update_tx

  def perform(wd_tx_hash)
    AppChainNetwork.new.update_tx(wd_tx_hash)
  end
end
