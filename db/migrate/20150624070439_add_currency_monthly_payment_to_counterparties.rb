class AddCurrencyMonthlyPaymentToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :currency_monthly_payment, :string, default: "USD"
  end
end
