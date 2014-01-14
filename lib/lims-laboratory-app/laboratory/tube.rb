require 'common'
require 'lims-laboratory-app/laboratory/location_resource'
require 'lims-laboratory-app/laboratory/receptacle.rb'

module Lims::LaboratoryApp
  module Laboratory
    # Piece of laboratory. 
    # Can have something in it and probably a label or something to identifiy it.
    class Tube
      include LocationResource
      include Receptacle
      # Type contains the actual type of the tube, for example Eppendorf.
      attribute :type, String, :required => false
      # Store the maximum volume a tube can hold in ml.
      attribute :max_volume, Numeric, :gte => 0, :required => false
    end
  end
end
