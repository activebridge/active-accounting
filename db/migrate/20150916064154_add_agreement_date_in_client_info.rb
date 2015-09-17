class AddAgreementDateInClientInfo < ActiveRecord::Migration
  def change
    add_column :client_infos, :agreement_date, :date
    add_column :vendor_infos, :agreement_date, :date
  end
end
