class AddTypeToRegisters < ActiveRecord::Migration
  def change
    add_column :registers, :type, :string
  end
end
