# frozen_string_literal: true

class EthToEbcTransferJob < ApplicationJob
  queue_as :eth_to_ebc_transfers
  # include Sidekiq::Worker
  # sidekiq_options queue: 'eth_to_ebc_transfers', unique_across_queues: true

  def perform(eth_tx_hash, nonce)
    # Do something later
    EthereumNetwork.new.transfer(eth_tx_hash, nonce)
  end
end
