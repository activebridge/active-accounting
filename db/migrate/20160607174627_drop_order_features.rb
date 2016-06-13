class DropOrderFeatures < ActiveRecord::Migration
  def up
    @old_table = 'order_features'
    @new_table = 'features_vendor_orders'
    change_join_table

    drop_table :order_features
  end

  def down
    create_table :order_features do |t|
      t.references :vendor_order, index: true
      t.references :feature, index: true

      t.timestamps
    end

    @old_table = 'features_vendor_orders'
    @new_table = 'order_features'
    change_join_table
  end

  def change_join_table
    sql = "SELECT old_records.vendor_order_id, old_records.feature_id, old_records.created_at,
     old_records.updated_at FROM #{@old_table} old_records"
    records_array = ActiveRecord::Base.connection.exec_query(sql).rows
    if records_array.present?
      records_string = records_array.map { |values| "('#{values[0]}', '#{values[1]}', '#{values[2].to_s(:db)}', '#{values[3].to_s(:db)}')"}.join(', ')
      sql_insert = "INSERT INTO #{@new_table} (vendor_order_id, feature_id, created_at, updated_at) VALUES " + records_string
      records = ActiveRecord::Base.connection.insert(sql_insert)
    end
  end
end
