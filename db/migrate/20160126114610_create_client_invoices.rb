class CreateClientInvoices < ActiveRecord::Migration
  def change
    create_table :client_invoices do |t|
      t.date :month
      t.references :customer, index: true

      t.timestamps
    end
  end
end
