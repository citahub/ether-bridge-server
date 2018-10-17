class AlterSomeColumns < ActiveRecord::Migration[5.2]
  def change
    # change_column :eth_to_ebcs, :eth_block_at, :bigint
    remove_column :eth_to_ebcs, :eth_block_at, :datetime
    add_column :eth_to_ebcs, :eth_block_timestamp, :string

    rename_column :eth_to_ebcs, :ac_block_height, :ac_block_num

    remove_column :eth_to_ebcs, :ac_block_at, :datetime
    add_column :eth_to_ebcs, :ac_block_timestamp, :bigint

    # ebc_to_eths
    remove_column :ebc_to_eths, :eth_tx_at, :datetime
    add_column :ebc_to_eths, :eth_tx_timestamp, :string
  end
end
