::Sequel.migration do
  change do
    alter_table(:labels) do
      add_index [:labellable_id, :position], :unique => true
    end
  end
end
