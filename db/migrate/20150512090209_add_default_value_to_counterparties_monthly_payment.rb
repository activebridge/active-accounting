class AddDefaultValueToCounterpartiesMonthlyPayment < ActiveRecord::Migration
  def change
    change_column :counterparties, :monthly_payment, :boolean, default: false
  end
end
