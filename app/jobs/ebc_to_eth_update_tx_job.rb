class EbcToEthUpdateTxJob < ApplicationJob
  queue_as :ebc_to_eth_update_tx
  # sidekiq_options :retry => 10

  def perform(wd_tx_hash)
    AppChainNetwork.new.update_tx(wd_tx_hash)
  end
end
