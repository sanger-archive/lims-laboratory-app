::Sequel.migration do
  change do
    alter_table(:aliquots) do
      add_foreign_key :snp_assay_id, :snp_assays, :key => :id
    end
  end
end
