class AddCustomerIdToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :customer_id, :integer
  end
end
