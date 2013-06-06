require 'lims-core/resource'
require 'lims-laboratory-app/laboratory/container'
require 'lims-laboratory-app/laboratory/container_element'

module Lims::LaboratoryApp
  module Laboratory
    # Filter Paper is a labware which can contains samples.
    # It has a number of rows and columns. We call them locations.
    # Each locations can contains 0 or more different samples.
    # The filter paper can contains a barcode (either Sanger generated
    # or provided with the filter paper by an external company).
    class FilterPaper
      include Lims::Core::Resource
      extend Lims::LaboratoryApp::Laboratory::ContainerElement

      # This method defines the name of the container element.
      def self.element_name
        :Location
      end

      # This method defines the type of the container element.
      def self.element_type
        Lims::LaboratoryApp::Laboratory::FilterPaper::Location
      end

      # A Location is a Receptacle, which can contains
      # 0 or more different samples
      Location = declare_element(element_name)

      # creates the matrix of container elements (Locations)
      create_container_elements(element_type)
    end
  end
end
