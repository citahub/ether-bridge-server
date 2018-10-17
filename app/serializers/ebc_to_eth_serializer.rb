class EbcToEthSerializer < ActiveModel::Serializer
  attributes :id, :address, :value, :initialized_at, :wd_tx_hash, :wdid, :wd_block_num, :eth_tx_hash, :eth_block_num, :eth_tx_timestamp, :burn_tx_hash, :burn_block_num, :status, :status_updated_at, :created_at, :updated_at
end
