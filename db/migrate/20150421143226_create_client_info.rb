class CreateClientInfo < ActiveRecord::Migration
  def change
    create_table :client_infos do |t|
      t.references :customer, index: true
      t.string     :name
      t.string     :agreement
      t.references :invoice, index: true
      t.string     :address
      t.string     :repr_name

      t.timestamps
    end
  end
end
