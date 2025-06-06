class CreateDatabaseFunctions < ActiveRecord::Migration[7.0]
  def up
    return unless ActiveRecord::Base.connection.adapter_name.downcase.include?('postgresql')

    execute <<-SQL
      CREATE OR REPLACE FUNCTION region_exists(regions_json json, target_region text)
      RETURNS boolean AS $$
      BEGIN
        RETURN regions_json ? target_region;
      END;
      $$ LANGUAGE plpgsql IMMUTABLE;
    SQL

    execute <<-SQL
      CREATE OR REPLACE FUNCTION get_active_toggles(tab_id_param integer)
      RETURNS TABLE(
        id integer,
        title varchar,
        type varchar,
        image_url varchar,
        landing_url varchar,
        start_date date,
        end_date date,
        regions json
      ) AS $$
      BEGIN
        RETURN QUERY
        SELECT 
          t.id,
          t.title,
          t.type,
          t.image_url,
          t.landing_url,
          t.start_date,
          t.end_date,
          t.regions
        FROM toggles t
        WHERE t.tab_id = tab_id_param
          AND t.deleted_at IS NULL
          AND t.start_date <= CURRENT_DATE
          AND t.end_date >= CURRENT_DATE;
      END;
      $$ LANGUAGE plpgsql;
    SQL
  end

  def down
    return unless ActiveRecord::Base.connection.adapter_name.downcase.include?('postgresql')

    execute "DROP FUNCTION IF EXISTS region_exists(json, text);"
    execute "DROP FUNCTION IF EXISTS get_active_toggles(integer);"
  end
end