::Sequel.migration do
  change do
    alter_table(:tube_rack_slots) do
      # A tube can appear in no more than one tube_rack
      add_unique_constraint :tube_id
    end
  end
end
