require 'common'
require 'lims-core/resource'

module Lims::LaboratoryApp
  module Organization
    # This class stores the shipping address of a labware.
    class Location
      include Lims::Core::Resource
      attribute :name, String, :required => true, :initializable => true
      attribute :address, String, :required => true, :initializable => true
      attribute :internal, Boolean, :default => true, :required => false, :initializable => true
    end
  end
end
