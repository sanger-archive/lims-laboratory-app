::Sequel.migration do
  up do
    create_table(:assays) do
      primary_key :id
      String :name
      String :allele_x
      String :allele_y
    end
  end

  down do
    drop_table(:assays)
  end
end
