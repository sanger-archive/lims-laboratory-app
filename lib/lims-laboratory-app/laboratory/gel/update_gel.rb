require 'lims-laboratory-app/laboratory/gel'
require 'lims-laboratory-app/laboratory/container/update_container_action'

module Lims::LaboratoryApp
  module Laboratory
    class Gel
      class UpdateGel
        include Container::UpdateContainerAction 

        attribute :gel, Laboratory::Gel, :required => true, :writer => :private
        attribute :windows, Hash, :required => false, :writer => :private, :default => {}

        def container_symbol
          :gel
        end

        def elements_symbol
          :windows
        end

        def _call_in_session(session)
          update(session)
        end
      end

      Update = UpdateGel
    end
  end
end
