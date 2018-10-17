class EbcToEthProcessConfirmTxJob < ApplicationJob
  queue_as :ebc_to_eth_process_confirm_tx

  def perform
    loop do
      AppChainNetwork.new.confirm_tx
      sleep(3)
    end
  end
end
