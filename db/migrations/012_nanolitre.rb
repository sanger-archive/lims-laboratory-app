::Sequel.migration do
  up do
    self[:aliquots].exclude(:quantity => nil).where(:type => "solvent").update(:quantity => Sequel.expr(:quantity) * 1000)
  end

  down do
    self[:aliquots].exclude(:quantity => nil).where(:type => "solvent").update(:quantity => Sequel.expr(:quantity) / 1000)
  end
end
