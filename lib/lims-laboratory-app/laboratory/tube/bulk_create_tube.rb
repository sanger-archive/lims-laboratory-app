require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/tube/create_tube_shared'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class BulkCreateTube
        include Lims::Core::Actions::Action
        include CreateTubeShared

        attribute :tubes, Array, :required => true, :writer => :private

        def _call_in_session(session)
          result = []
          tubes.each do |parameters|
            result <<  _create(parameters["type"], parameters["max_volume"], parameters["aliquots"], session)
          end

          {:tubes => result.map { |e| e[:tube] }}
        end
      end
    end
  end
end
