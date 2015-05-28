class AddFirstLoggedToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :signed_in, :boolean, default: false
  end
end
