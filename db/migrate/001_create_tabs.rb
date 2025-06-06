class CreateTabs < ActiveRecord::Migration[7.0]
  def change
    create_table :tabs do |t|
      t.string :title, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.json :regions, null: false, default: []

      t.timestamps
    end

    add_index :tabs, :title
    add_index :tabs, [:start_date, :end_date]
    add_index :tabs, :regions, using: :gin
    add_check_constraint :tabs, "end_date >= start_date", name: "tabs_date_range_check"
  end
end