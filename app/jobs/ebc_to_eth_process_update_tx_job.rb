class EbcToEthProcessUpdateTxJob < ApplicationJob
  queue_as :ebc_to_eth_process_update_tx

  def perform
    loop do
      AppChainNetwork.new.process_update_tx
      sleep(3)
    end
  end
end
