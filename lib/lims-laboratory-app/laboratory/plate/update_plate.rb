
# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-core/actions/action'

require 'lims-laboratory-app/laboratory/plate'

module Lims::LaboratoryApp
  module Laboratory
    # Update a plate and set a new type and/or a new quantity to 
    # all its aliquots.
    class Plate
      class UpdatePlate
        include Lims::Core::Actions::Action

        # The plate to update
        attribute :plate, Laboratory::Plate, :required => true, :writer => :private
        attribute :aliquot_type, String, :required => false, :writer => :private
        attribute :aliquot_quantity, Numeric, :required => false, :writer => :private 
        # Type is the actual type of the plate, not the role in the order.
        attribute :type, String, :required => false, :writer => :private
        # @example:
        # {"A1" => {"sample" => sample_1, "aliquot_type" => "type", "aliquot_quantity" => 10}, ...}
        # Update the aliquot containing sample_1 with aliquot_type and aliquot_quantity.
        attribute :wells, Hash, :required => false, :writer => :private, :default => {}

        def _call_in_session(session)
          plate.type = type if type

          wells.each do |location, well_data|
            sample = well_data["sample"]
            aliquot_type = well_data["aliquot_type"]
            aliquot_quantity = well_data["aliquot_quantity"]
            aliquot = plate[location.to_s].content.find { |aliquot| aliquot.sample == sample }

            if aliquot
              aliquot.type = aliquot_type if aliquot_type
              aliquot.quantity = aliquot_quantity if aliquot_quantity
            end
          end

          plate.each do |well|
            well.each do |aliquot|
              aliquot.type = aliquot_type if aliquot_type
              aliquot.quantity = aliquot_quantity if aliquot_quantity
            end
          end
          {:plate => plate}
        end
      end
    end
    end

  module Laboratory
    class Plate
      Update = UpdatePlate
    end
  end
end
