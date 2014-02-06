::Sequel.migration do
  change do
    alter_table(:labellables) do
      add_unique_constraint [:name]
    end
  end
end
