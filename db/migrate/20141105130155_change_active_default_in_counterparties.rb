class ChangeActiveDefaultInCounterparties < ActiveRecord::Migration
  def change
    change_column_default :counterparties, :active, true
  end
end
