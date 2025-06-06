class AddAdditionalConstraints < ActiveRecord::Migration[7.0]
  def change
    add_check_constraint :tabs, "json_array_length(regions) > 0", name: "tabs_regions_not_empty"
    add_check_constraint :toggles, "json_array_length(regions) > 0", name: "toggles_regions_not_empty"
    add_check_constraint :tabs, "trim(title) != ''", name: "tabs_title_not_empty"
    add_check_constraint :toggles, "trim(title) != ''", name: "toggles_title_not_empty"
    add_check_constraint :link_generators, "url IS NOT NULL AND trim(url) != ''", name: "link_generators_url_not_empty"
  end
end