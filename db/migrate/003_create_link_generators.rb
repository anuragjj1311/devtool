class CreateLinkGenerators < ActiveRecord::Migration[7.0]
  def change
    create_table :link_generators do |t|
      t.string :type, null: false
      t.text :url
      t.references :linkable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :link_generators, :type
    add_index :link_generators, [:linkable_type, :linkable_id]
    add_check_constraint :link_generators, "type IN ('DirectLink', 'ActivityLink')", name: "link_generators_type_check"
  end
end