class CreateToggles < ActiveRecord::Migration[7.0]
  def change
    create_table :toggles do |t|
      t.string :title, null: false
      t.string :type, null: false # STI: Shop, Category
      t.string :image_url
      t.string :landing_url
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.json :regions, null: false, default: []
      t.datetime :deleted_at
      t.references :tab, null: false, foreign_key: true

      t.timestamps
    end

    # Additional indexes (skip tab_id only)
    add_index :toggles, :title
    add_index :toggles, :type
    add_index :toggles, :deleted_at
    add_index :toggles, [:start_date, :end_date]

    # GIN index only works in PostgreSQL
    if ActiveRecord::Base.connection.adapter_name.downcase.include?("postgresql")
      add_index :toggles, :regions, using: :gin
    end

    add_index :toggles, [:tab_id, :type]
    add_index :toggles, [:tab_id, :deleted_at]
    add_index :toggles, [:tab_id, :deleted_at, :start_date, :end_date], name: 'index_toggles_active_with_dates'

    # Check constraints
    add_check_constraint :toggles, "end_date >= start_date", name: "toggles_date_range_check"
    add_check_constraint :toggles, "type IN ('Shop', 'Category')", name: "toggles_type_check"
  end
end
