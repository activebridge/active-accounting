class CreateVendorInfos < ActiveRecord::Migration
  def change
    create_table :vendor_infos do |t|
      t.string  :name
      t.integer :ipn
      t.string  :address
      t.string  :contract
      t.integer :account
      t.string  :bank
      t.integer :mfo
      t.references :vendor, index: true

      t.timestamps
    end
  end
end
