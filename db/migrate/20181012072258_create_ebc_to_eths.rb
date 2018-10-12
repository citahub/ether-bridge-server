class CreateEbcToEths < ActiveRecord::Migration[5.2]
  def change
    create_table :ebc_to_eths do |t|
      t.string :address, index: true
      t.string :value
      t.datetime :initialized_at
      t.string :wd_tx_hash
      t.decimal :wdid, precision: 260
      t.integer :wd_block_num
      t.string :eth_tx_hash
      t.integer :eth_block_num
      t.datetime :eth_tx_at
      t.string :burn_tx_hash
      t.integer :burn_block_num
      t.integer :status, default: 0, index: true
      t.datetime :status_updated_at

      t.timestamps
    end
  end
end
