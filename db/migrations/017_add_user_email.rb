::Sequel.migration do
  change do   
    alter_table(:users)  do
      add_column :email, String
    end
  end
end
