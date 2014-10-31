class ChangeValueToFloatInRegisters < ActiveRecord::Migration
  def change
    change_column :registers, :value, :float
  end
end
