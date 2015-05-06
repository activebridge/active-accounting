class AddApproveHoursToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :approve_hours, :boolean, default: false
  end
end
