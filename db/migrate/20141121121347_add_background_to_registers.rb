class AddBackgroundToRegisters < ActiveRecord::Migration
  def change
    add_column :registers, :background, :string
  end
end
