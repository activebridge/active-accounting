class AddMonthlyPaymentAndItsValueToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :value_payment, :float
    add_column :counterparties, :monthly_payment, :boolean
  end
end
