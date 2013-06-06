require 'lims-laboratory-app/laboratory/receptacle'
require 'lims-laboratory-app/laboratory/container'

module Lims::LaboratoryApp
  module Laboratory
    module ContainerElement

      # This method dynamically creates a new class.
      # This class is a container element. It behaves like a Receptacle.
      def declare_element(element_name)
        const_set(element_name.to_s.capitalize, Class.new do include Receptacle end)
      end

      # This method creates a matrix of container elements
      def matrix_of(element_name)
        is_matrix_of(declare_element(element_name)) do |container, container_element|
          (container.number_of_rows*container.number_of_columns).times.map { container_element.new }
        end
      end
      
    end
  end
end
