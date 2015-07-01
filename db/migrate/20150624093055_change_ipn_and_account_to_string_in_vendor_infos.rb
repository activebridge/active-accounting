class ChangeIpnAndAccountToStringInVendorInfos < ActiveRecord::Migration
  def change
    change_column :vendor_infos, :ipn, :string
    change_column :vendor_infos, :account, :string
  end
end
