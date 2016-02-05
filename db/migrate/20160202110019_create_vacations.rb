class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.references :vendor, index: true
      t.date :start
      t.date :ending
    end
  end
end
