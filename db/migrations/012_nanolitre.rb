::Sequel.migration do
  up do
    fetch('UPDATE aliquots SET quantity = quantity*1000 WHERE quantity is not null AND `type` = "solvent"').all
  end

  down do
    fetch('UPDATE aliquots SET quantity = quantity/1000 WHERE quantity is not null AND `type` = "solvent"').all
  end
end
