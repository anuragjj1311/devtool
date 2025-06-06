# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_06_06_055521) do
  create_table "link_generators", force: :cascade do |t|
    t.string "type", null: false
    t.text "url"
    t.string "linkable_type", null: false
    t.integer "linkable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linkable_id"], name: "index_link_generators_unique_per_shop", unique: true, where: "linkable_type = 'Shop'"
    t.index ["linkable_type", "linkable_id"], name: "index_link_generators_on_linkable"
    t.index ["linkable_type", "linkable_id"], name: "index_link_generators_on_linkable_type_and_linkable_id"
    t.index ["type"], name: "index_link_generators_on_type"
    t.check_constraint "type IN ('DirectLink', 'ActivityLink')", name: "link_generators_type_check"
    t.check_constraint "url IS NOT NULL AND trim(url) != ''", name: "link_generators_url_not_empty"
  end

  create_table "tabs", force: :cascade do |t|
    t.string "title", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.json "regions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["regions"], name: "index_tabs_on_regions"
    t.index ["start_date", "end_date"], name: "index_tabs_on_start_date_and_end_date"
    t.index ["title"], name: "index_tabs_on_title"
    t.check_constraint "end_date >= start_date", name: "tabs_date_range_check"
    t.check_constraint "json_array_length(regions) > 0", name: "tabs_regions_not_empty"
    t.check_constraint "trim(title) != ''", name: "tabs_title_not_empty"
  end

  create_table "toggles", force: :cascade do |t|
    t.string "title", null: false
    t.string "type", null: false
    t.string "image_url"
    t.string "landing_url"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.json "regions", default: [], null: false
    t.datetime "deleted_at"
    t.integer "tab_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_toggles_on_deleted_at"
    t.index ["start_date", "end_date"], name: "index_toggles_on_start_date_and_end_date"
    t.index ["tab_id", "deleted_at", "start_date", "end_date"], name: "index_toggles_active_with_dates"
    t.index ["tab_id", "deleted_at"], name: "index_toggles_on_tab_id_and_deleted_at"
    t.index ["tab_id", "title"], name: "index_toggles_unique_title_per_tab", unique: true, where: "deleted_at IS NULL"
    t.index ["tab_id", "type"], name: "index_toggles_on_tab_id_and_type"
    t.index ["tab_id"], name: "index_toggles_on_tab_id"
    t.index ["title"], name: "index_toggles_on_title"
    t.index ["type", "deleted_at", "start_date", "end_date"], name: "index_toggles_type_active_dates"
    t.index ["type"], name: "index_toggles_on_type"
    t.check_constraint "end_date >= start_date", name: "toggles_date_range_check"
    t.check_constraint "json_array_length(regions) > 0", name: "toggles_regions_not_empty"
    t.check_constraint "trim(title) != ''", name: "toggles_title_not_empty"
    t.check_constraint "type IN ('Shop', 'Category')", name: "toggles_type_check"
  end

  add_foreign_key "toggles", "tabs"
end
