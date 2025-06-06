class ChangeRegionsToJson < ActiveRecord::Migration[7.2]
  def change
    change_column :tabs, :regions, :json
    change_column :toggles, :regions, :json
  end
end