class CreatePaymentHistories < ActiveRecord::Migration
  def change
    create_table :payment_histories do |t|
      t.references :counterparty, index: true
      t.integer :admin_id
      t.float :value_payment

      t.timestamps
    end
  end
end
