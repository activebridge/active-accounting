class AddMonthToEstimates < ActiveRecord::Migration
  def change
    add_column :estimates, :month, :date
  end
end
