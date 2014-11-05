class ChangeActiveToDefaultInCounterparties < ActiveRecord::Migration
  def change
  	change_column :counterparties, :active, :boolean, :default => true
  end
end
