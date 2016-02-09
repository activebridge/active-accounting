class CreateClientActs < ActiveRecord::Migration
  def change
    create_table :client_acts do |t|
      t.string :total_money
      t.date :month
      t.references :customer, index: true

      t.timestamps
    end
  end
end
