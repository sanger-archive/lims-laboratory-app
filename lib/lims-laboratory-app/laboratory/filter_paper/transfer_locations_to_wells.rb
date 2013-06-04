require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/plate'
require 'lims-laboratory-app/laboratory/transfer_action'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      # This action transfer the content from 1 or more locations 
      # on a filter paper to 1 or more wells on a plate
      class TransferLocationsToWells
        include Lims::Core::Actions::Action
        include TransferAction

        attribute :source, Laboratory::FilterPaper, :required => true, :writer => :private
        attribute :target, Laboratory::Plate, :required => true, :writer => :private
        attribute :transfer_map, Hash, :required => true, :writer => :private

        def _call_in_session(session)
          transfer_map.each do |from, to|
            source_location = source[from]
            target_well = target[to]
            target_well << source_location.take_fraction(1)
          end

          { :source => source, :target => target }
        end

      end
    end
  end
end
