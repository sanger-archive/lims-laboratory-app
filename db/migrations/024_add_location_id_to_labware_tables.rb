::Sequel.migration do
  change do
    [:flowcells, :tubes, :spin_columns, :plates, :tube_racks, :gels, :filter_papers, :fluidigms].each do |labware_table|
      alter_table(labware_table) do
        add_foreign_key :location_id, :locations, :key => :id
      end
    end
  end
end
