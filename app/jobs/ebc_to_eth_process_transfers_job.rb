class EbcToEthProcessTransfersJob < ApplicationJob
  queue_as :ebc_to_eth_process_transfers

  def perform
    loop do
      AppChainNetwork.new.process_transfers
      sleep(3)
    end
  end
end
