class EbcToEthListenEventLogsJob < ApplicationJob
  queue_as :ebc_to_eth_listen_event_logs

  def perform(*args)
    loop do
      AppChainNetwork.new.listen_event_logs
      sleep(3)
    end
  end
end
