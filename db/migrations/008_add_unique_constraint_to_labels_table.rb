::Sequel.migration do
  change do
    alter_table(:labels) do
      add_unique_constraint [:labellable_id, :position]
    end
  end
end
