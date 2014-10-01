class CreateCounterparties < ActiveRecord::Migration
  def change
    create_table :counterparties do |t|
      t.string :name
      t.date :start_date
      t.boolean :active

      t.timestamps
    end
  end
end
