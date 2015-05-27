class AddTitleEnToClientInfos < ActiveRecord::Migration
  def change
    add_column :client_infos, :title_en, :string
    add_column :client_infos, :title_ua, :string
  end
end
