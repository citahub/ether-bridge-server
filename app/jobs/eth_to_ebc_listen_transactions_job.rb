class EthToEbcListenTransactionsJob < ApplicationJob
  queue_as :eth_to_ebc_listen_transactions
  # include Sidekiq::Worker
  # sidekiq_options unique_across_queues: true

  def perform
    loop do
      EthereumNetwork.new.listen_transactions
      sleep(3)
    end
  end
end
