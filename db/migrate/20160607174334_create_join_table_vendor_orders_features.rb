class CreateJoinTableVendorOrdersFeatures < ActiveRecord::Migration
  def change
    create_join_table :vendor_orders, :features do |t|
      t.timestamps
    end
  end
end
