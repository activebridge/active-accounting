class ChangeAgreementInClientInfo < ActiveRecord::Migration
  def change
    rename_column :client_infos, :agreement, :agreement_number
  end
end
