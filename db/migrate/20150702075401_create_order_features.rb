class CreateOrderFeatures < ActiveRecord::Migration
  def change
    create_table :order_features do |t|
      t.references :vendor_order, index: true
      t.references :feature, index: true

      t.timestamps
    end
  end
end
