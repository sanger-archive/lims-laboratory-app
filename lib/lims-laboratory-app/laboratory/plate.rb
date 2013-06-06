require 'lims-core/resource'
require 'lims-laboratory-app/laboratory/container'

require 'facets/hash'
require 'facets/array'

module Lims::LaboratoryApp
  module Laboratory
    # A plate is a plate as seen in a laboratory, .i.e
    # a rectangular bits of platics with wells and some 
    # readable labels on it.
    # TODO add label behavior
    class Plate 
      include Lims::Core::Resource
      # Type contains the actual type of the plate.
      attribute :type, String, :required => false

      def attributes
        {type: @type,
          number_of_rows: @number_of_rows,
          number_of_columns: @number_of_columns
        }
      end

      # The well of a {Plate}. 
      # Contains some chemical substances.
#      class Well
#        include Receptacle
      # This method defines the name of the container element.
      def self.element_name
        :Well
      end

      # This method defines the type of the container element.
      def self.element_type
        Lims::LaboratoryApp::Laboratory::Plate::Well
      end

      # The well of a {Plate}.
      # Contains some chemical substances.
      Well = declare_element(element_name)

      # creates the matrix of container elements (Wells)
      create_container_elements(element_type)

#      # creates the matrix of container elements (Wells)
      matrix_of(:Well)

      # This should be set by the user.
      # We mock it to give pools by column
      # @return [Hash<String, Array<String>] pools pool name => list of wells name
      def pools
        1.upto(number_of_columns).mash do |c|
          [c, 1.upto(number_of_rows).map { |r| indexes_to_element_name(r-1,c-1) } ]
        end
      end
    end
  end
end
