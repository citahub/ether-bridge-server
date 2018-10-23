# frozen_string_literal: true

class EthToEbcSerializer < ActiveModel::Serializer
  attributes :id, :address, :value, :initialized_at, :eth_tx_hash, :eth_block_num, :eth_block_timestamp, :ac_tx_hash, :ac_tx_at, :ac_block_num, :ac_block_timestamp, :status, :status_updated_at, :created_at, :updated_at
end
