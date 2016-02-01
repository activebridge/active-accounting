class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.float :social
      t.float :single
      t.float :cash

      t.timestamps
    end

    Tax.create(social: 1, single: 1, cash: 1)
  end
end
