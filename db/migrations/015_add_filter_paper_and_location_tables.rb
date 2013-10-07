::Sequel.migration do
  up do
    create_table(:filter_papers) do
      primary_key :id
      Integer :number_of_rows
      Integer :number_of_columns
    end

    create_table(:locations) do
      primary_key :id
      foreign_key :filter_paper_id, :filter_papers, :key => :id
      Integer :position
      foreign_key :aliquot_id, :aliquots, :key => :id
    end
  end

  down do
    drop_table(:locations)
    drop_table(:filter_papers)
  end
end
