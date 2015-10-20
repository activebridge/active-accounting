class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.date :month
      t.references :customer, index: true

      t.timestamps
    end
  end
end
