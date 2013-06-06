require 'lims-core/resource'
require 'lims-laboratory-app/laboratory/container'
require 'lims-laboratory-app/laboratory/container_element'

require 'facets/hash'
require 'facets/array'

module Lims::LaboratoryApp
  module Laboratory
    # Gel is a labware as seen in a laboratory.
    # It has a number of rows and number of columns property.
    # Gel contains Windows and has some readable labels on it (i.e. barcode).
    class Gel
      include Lims::Core::Resource
      extend Lims::LaboratoryApp::Laboratory::ContainerElement

      # This method defines the name of the container element.
      def self.element_name
        :Window
      end

      # This method defines the type of the container element.
      def self.element_type
        Lims::LaboratoryApp::Laboratory::Gel::Window
      end

      # The Window can contain a receptacle, which is a chemical substance.
      Window = declare_element(element_name)

      # creates the matrix of container elements (Windows)
      create_container_elements(element_type)
    end
  end
end
