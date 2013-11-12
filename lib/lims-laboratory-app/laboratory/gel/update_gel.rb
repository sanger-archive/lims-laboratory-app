require 'lims-laboratory-app/laboratory/gel'
require 'lims-laboratory-app/laboratory/container/update_container_trait'
require 'lims-core/actions/action'

module Lims::LaboratoryApp
  module Laboratory
    class Gel
      class UpdateGel
        include Lims::Core::Actions::Action

        attribute :gel, Laboratory::Gel, :required => true, :writer => :private
        attribute :windows, Hash, :required => false, :writer => :private, :default => {}

        does "lims/laboratory_app/laboratory/container/update_container", {
          :container_name => "gel", :elements_name => "windows"
        }
      end

      Update = UpdateGel
    end
  end
end
