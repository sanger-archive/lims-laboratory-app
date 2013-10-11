require 'common'

::Sequel.migration do
  up do
    # Change all serialized column initial Marshalled to JSON.
    self[:orders].each do |row|
      [:state, :parameters].each do |column|
        row[column].andtap { |value| row[column] = Lims::Core::Helpers::to_json(Marshal.load(value)) }
      end
      self[:orders].filter(:id => row.delete(:id)).update(row)
    end
  end
end
