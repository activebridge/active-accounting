class CreateRegisters < ActiveRecord::Migration
  def change
    create_table :registers do |t|
      t.date :date
      t.integer :article_id
      t.integer :counterparty_id
      t.integer :value
      t.text :notes

      t.timestamps
    end
  end
end
