::Sequel.migration do
  change do
    alter_table :items do
      add_index :uuid 
    end
  end
end
