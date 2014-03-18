::Sequel.migration do
  up do
    create_table(:fluidigms) do
      primary_key :id
      Integer :number_of_rows
      Integer :number_of_columns
    end

    create_table(:fluidigm_wells) do
      primary_key :id
      foreign_key :fluidigm_id, :fluidigms, :key => :id
      Integer :position
      foreign_key :aliquot_id, :aliquots, :key => :id
    end
  end

  down do
    drop_table(:fluidigm_wells)
    drop_table(:fluidigms)
  end
end
