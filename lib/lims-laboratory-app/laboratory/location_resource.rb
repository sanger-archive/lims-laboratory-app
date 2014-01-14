require 'virtus'
require 'aequitas/virtus_integration'
require 'lims-core/resource'
require 'lims-laboratory-app/organization/location'

module Lims::LaboratoryApp
  module Laboratory  
    module LocationResource

      def self.included(klass)
        klass.class_eval do
          include Virtus
          include Aequitas
          include Lims::Core::Resource
  
          attribute :location, Lims::LaboratoryApp::Organization::Location, :required => false
        end
      end
    end
  end
end
