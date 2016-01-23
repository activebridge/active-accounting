class AddCurrencyToRegisters < ActiveRecord::Migration
  def change
    add_column :registers, :currency, :string, default: 'UAH'
  end
end
