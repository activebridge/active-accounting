class AddEmailToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :email, :string
  end
end
