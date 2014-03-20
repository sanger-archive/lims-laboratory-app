::Sequel.migration do
  change do
    [:flowcells, :tubes, :spin_columns, :plates, :tube_racks, :gels, :filter_papers, :fluidigms].each do |labware_table|
      table_name = "#{labware_table}_revision"
      next unless tables.include? table_name
      alter_table(table_name) do
        add_column :location_id, :locations
      end
    end
  end
end
