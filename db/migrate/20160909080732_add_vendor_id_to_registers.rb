class AddVendorIdToRegisters < ActiveRecord::Migration
  def change
    add_column :registers, :vendor_id, :integer, index: true
  end
end
