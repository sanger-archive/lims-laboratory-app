require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/tube/create_tube'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class BulkCreateTube
        include Lims::Core::Actions::Action

        attribute :tubes, Array, :required => true, :writer => :private

        def _call_in_session(session)
          result = tubes.map do |parameters|
            tube_action = CreateTube.new(parameters)
            tube_action.send(:_call_in_session, session)
          end

          {:tubes => result.map { |e| e[:tube] }}
        end
      end
    end
  end
end
