class EthToEbcSerializer < ActiveModel::Serializer
  attributes :id, :address, :value, :initialized_at, :eth_tx_hash, :eth_block_num, :eth_block_at, :ac_tx_hash, :ac_tx_at, :ac_block_height, :ac_block_at, :status, :status_updated_at, :created_at, :updated_at
end
