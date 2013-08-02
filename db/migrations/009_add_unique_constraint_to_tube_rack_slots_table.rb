::Sequel.migration do
  change do
    alter_table(:tube_rack_slots) do
      # A tube can appear in no more than one tube_rack
      add_index :tube_id, :unique => true
    end
  end
end
