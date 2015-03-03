class AddTypeToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :type, :string
  end
end
