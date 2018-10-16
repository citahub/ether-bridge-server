Sidekiq.configure_client do |config|
  Rails.application.config.after_initialize do
    # Your code goes here
    names = Sidekiq::Queue.all.map(&:name)

    unless names.include?("eth_to_ebc_process_transfers")
      EthToEbcProcessTransfersJob.perform_later
    end

    unless names.include?("eth_to_ebc_listen_transactions")
      EthToEbcListenTransactionsJob.perform_later
    end

    unless names.include?("eth_to_ebc_process_update_tx")
      EthToEbcProcessUpdateTxJob.perform_later
    end
  end
end
