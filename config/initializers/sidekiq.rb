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

    unless names.include?("ebc_to_eth_listen_event_logs")
      EbcToEthListenEventLogsJob.perform_later
    end

    unless names.include?("ebc_to_eth_process_confirm_tx")
      EbcToEthProcessConfirmTxJob.perform_later
    end

    unless names.include?("ebc_to_eth_process_transfers")
      EbcToEthProcessTransfersJob.perform_later
    end

    unless names.include?("ebc_to_eth_process_update_tx")
      EbcToEthProcessUpdateTxJob.perform_later
    end
  end
end
