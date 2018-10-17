class AlterEbcToEths < ActiveRecord::Migration[5.2]
  def change
    remove_column :ebc_to_eths, :initialized_at, :datetime
    add_column :ebc_to_eths, :initialized_timestamp, :bigint
  end
end
