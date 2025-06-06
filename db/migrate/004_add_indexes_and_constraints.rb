class AddIndexesAndConstraints < ActiveRecord::Migration[7.0]
  def change
    # Add toggle index for multiple conditions (runs on all DBs)
    add_index :toggles, [:type, :deleted_at, :start_date, :end_date],
              name: 'index_toggles_type_active_dates'

    # Only add the PostgreSQL-specific indexes if using PostgreSQL
    if ActiveRecord::Base.connection.adapter_name.downcase.include?('postgresql')
      # Partial index using CURRENT_DATE (not allowed in SQLite)
      add_index :tabs, [:start_date, :end_date],
                where: "start_date <= CURRENT_DATE AND end_date >= CURRENT_DATE",
                name: 'index_tabs_active_dates'

      # GIN indexes for JSON (PostgreSQL-specific)
      execute "CREATE INDEX CONCURRENTLY IF NOT EXISTS index_tabs_regions_gin ON tabs USING gin (regions)"
      execute "CREATE INDEX CONCURRENTLY IF NOT EXISTS index_toggles_regions_gin ON toggles USING gin (regions)"
    end
  end
end
