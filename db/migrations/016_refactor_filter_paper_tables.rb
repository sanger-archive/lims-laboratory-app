::Sequel.migration do
  change do
    alter_table(:filter_papers) do
      drop_column :number_of_rows
      drop_column :number_of_columns
    end

    alter_table(:locations) do
      drop_column :position
    end

    rename_table(:locations, :filter_paper_aliquots)
  end
end
