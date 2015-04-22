class RenameEstimates < ActiveRecord::Migration
  def change
    rename_table :estimates, :hours
  end
end
