class AddEmailToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :email, :string
    add_column :counterparties, :password, :string
  end
end
