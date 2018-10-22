class CreateEthToEbcs < ActiveRecord::Migration[5.2]
  def change
    create_table :eth_to_ebcs do |t|
      t.string :address, index: true
      t.string :value
      t.datetime :initialized_at
      t.string :eth_tx_hash
      t.integer :eth_block_num
      t.datetime :eth_block_at
      t.string :ac_tx_hash
      t.datetime :ac_tx_at
      t.integer :ac_block_height
      t.integer :ac_block_at
      t.integer :status, default: 0, index: true
      t.datetime :status_updated_at

      t.timestamps
    end
  end
end
