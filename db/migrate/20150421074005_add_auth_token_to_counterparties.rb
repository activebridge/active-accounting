class AddAuthTokenToCounterparties < ActiveRecord::Migration
  def change
    add_column :counterparties, :auth_token, :string
    add_column :counterparties, :password_reset_token, :string
    add_column :counterparties, :password_reset_sent_at, :datetime
  end
end
