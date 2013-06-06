require 'lims-laboratory-app/laboratory/receptacle'
require 'lims-laboratory-app/laboratory/container'

module Lims::LaboratoryApp
  module Laboratory
    module ContainerElement

      # This method dynamically creates a new class.
      # This class is a container element. It behaves like a Receptacle.
      def declare_element(element_name)
        Object.const_set(element_name.to_s.capitalize, Class.new do include Receptacle end)
      end

      # This method defines the name of the container element.
      # For example: in case of the container is a Plate, then we return :Well
      def element_name
        raise NotImplementedError
      end

      # This method defines the type of the container element.
      # For example: in case of the container is a Plate, then we return
      # Lims::LaboratoryApp::Laboratory::Plate::Well
      def element_type
        raise NotImplementedError
      end

      # This method creates a matrix of container elements
      def create_container_elements(element_type)
        is_matrix_of(element_type) do |container, container_element|
          (container.number_of_rows*container.number_of_columns).times.map { container_element.new }
        end
      end
      
    end
  end
end
