::Sequel.migration do
  up do
    create_table(:locations) do
      primary_key :id
      String :name
      String :address, :text => true
      boolean :internal
    end

    create_table(:shipping_requests) do
      primary_key :id
      foreign_key :location_id, :locations, :key => :id
      String :name # the UUID of the labware
    end
  end

  down do
    drop_table(:locations)
    drop_table(:shipping_requests)
  end
end
