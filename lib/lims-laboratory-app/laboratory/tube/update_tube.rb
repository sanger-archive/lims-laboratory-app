# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-core/actions/action'

require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/spin_column'

module Lims::LaboratoryApp
  module Laboratory
    # Update a tube and set a new type and/or a new quantity to 
    # all its aliquots.
    class Tube
      class UpdateTube
        include Lims::Core::Actions::Action

        # The tube to update
        attribute :tube, Laboratory::Tube, :required => true, :writer => :private
        # On update, all the aliquots in the tube will have the type
        # aliquot_type and the quantity aliquot_quantity.
        attribute :aliquot_type, String, :required => false, :writer => :private
        attribute :aliquot_quantity, Numeric, :required => false, :writer => :private 
        # The actual type of the tube, like Eppendorf.
        attribute :type, String, :required => false, :writer => :private
        attribute :max_volume, Numeric, :required => false, :writer => :private
        # Change the volume of the solvent (or create a solvent aliquot with the desired volume)
        attribute :volume, Numeric, :required => false, :writer => :private
        # Change the shipping location of the tube
        attribute :location, Organization::Location, :required => false

        def _call_in_session(session)
          update_tube(tube, volume, aliquot_type, aliquot_quantity, type, max_volume, location)
          {:tube => tube}
        end

        module UpdateTubeAction
          def update_tube(tube, volume=nil, aliquot_type=nil, aliquot_quantity=nil, type=nil, max_volume=nil, location=nil)
            tube.type = type if type
            tube.max_volume = max_volume if max_volume
            tube.each do |aliquot|
              aliquot.type = aliquot_type unless aliquot_type.nil?
              aliquot.quantity = aliquot_quantity unless aliquot_quantity.nil?
            end

            if volume
              solvent = tube.content.find { |aliquot| aliquot.type == Aliquot::Solvent }
              unless solvent
                solvent = Aliquot.new(:type => Aliquot::Solvent)
                tube << solvent
              end
              solvent.quantity = volume
            end

            tube.location = location if location
          end
        end
        include UpdateTubeAction
      end
    end
  end

  module Laboratory
    class Tube
      Update = UpdateTube
    end

    # As Tube and SpinColumn behave the same, update a spin column
    # redirects to update a tube action.
    class SpinColumn
      Update = Tube::UpdateTube
    end
  end
end
