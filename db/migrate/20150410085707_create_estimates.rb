class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.references :vendor, index: true
      t.references :customer, index: true
      t.integer :hours
      t.timestamps
    end
  end
end
