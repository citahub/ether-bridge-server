# frozen_string_literal: true

class EthToEbcUpdateTxJob < ApplicationJob
  queue_as :eth_to_ebc_update_tx

  def perform(eth_tx_hash)
    EthereumNetwork.new.update_tx(eth_tx_hash)
  end
end
