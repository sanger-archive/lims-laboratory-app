require 'common'
require 'lims-core/resource'

module Lims::LaboratoryApp
  module Organization
    # This class stores the shipping address of a labware.
    class Location
      include Lims::Core::Resource
      attribute :name, String, :required => true
      attribute :address, String, :required => true
      attribute :internal, TrueClass, :default => true, :required => false
    end
  end
end
