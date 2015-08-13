class CreateVendorOrders < ActiveRecord::Migration
  def change
    create_table :vendor_orders do |t|
      t.date :month
      t.references :vendor, index: true

      t.timestamps
    end
  end
end
