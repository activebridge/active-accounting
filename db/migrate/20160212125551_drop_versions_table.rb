class DropVersionsTable < ActiveRecord::Migration
  TEXT_BYTES = 1_073_741_823

  def up
    drop_table :versions
  end

  def down
    create_table :versions do |t|
      t.string   :item_type, null: false
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.text     :object, limit: TEXT_BYTES
      t.datetime :created_at
    end
    add_index :versions, [:item_type, :item_id]
  end
end
