class EthToEbcProcessTransfersJob < ApplicationJob
  queue_as :eth_to_ebc_process_transfers
  # include Sidekiq::Worker
  # sidekiq_options queue: 'eth_to_ebc_process_transfers', unique_across_queues: true

  def perform
    loop do
      EthereumNetwork.new.process_transfers
      sleep(3)
    end
  end
end
