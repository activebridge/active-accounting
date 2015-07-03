class CreateVendorActs < ActiveRecord::Migration
  def change
    create_table :vendor_acts do |t|
      t.string  :total_money
      t.date :month
      t.references :vendor, index: true

      t.timestamps
    end
  end
end
