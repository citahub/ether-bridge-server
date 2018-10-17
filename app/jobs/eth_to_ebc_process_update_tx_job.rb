class EthToEbcProcessUpdateTxJob < ApplicationJob
  queue_as :eth_to_ebc_process_update_tx

  def perform(*args)
    loop do
      EthereumNetwork.new.process_update_tx
      sleep(3)
    end
  end
end
