class AddUniqueConstraints < ActiveRecord::Migration[7.0]
  def change
    add_index :toggles, [:tab_id, :title], unique: true, where: "deleted_at IS NULL", name: 'index_toggles_unique_title_per_tab'
    add_index :link_generators, [:linkable_id], unique: true, where: "linkable_type = 'Shop'", name: 'index_link_generators_unique_per_shop'
  end
end