require 'lims-core/resource'
require 'lims-laboratory-app/laboratory/container'

require 'facets/hash'
require 'facets/array'

module Lims::LaboratoryApp
  module Laboratory
    # Fluidigm is a labware as seen in the laboratory.
    # It has a number of rows and number of columns property.
    # It is a rectangular bit of plastic and contains Wells for Assay and Samples.
    # It can have a layout of 96 Assay wells and 96 Sample wells or
    # 192 samples wells and 24 snp assay wells.
    # It can has some readable labels on it (i.e. barcode).
    class Fluidigm
      include Lims::Core::Resource

      FLUIDIGM_96_96  = 12*16
      FLUIDIGM_192_24 = 14*16
      NUMBER_OF_ASSAY_IN_A_GROUP = 3
      ASSAY           = 'A'
      SAMPLE          = 'S'

      InvalidContentError = Class.new(Lims::Core::Actions::Action::InvalidParameters)
      InvalidSizeError = Class.new(Lims::Core::Actions::Action::InvalidParameters)

      # creates the matrix of container elements (Wells),
      # which contains some chemical substances.
      matrix_of(:Well)

      # Converts an element name to an index of the underlying container
      # The result could be from 0 to size - 1
      def element_name_to_index(type, index)
        raise IndexOutOfRangeError unless type == Fluidigm::SAMPLE || type == Fluidigm::ASSAY
        raise Fluidigm::InvalidContentError, {
          "content" => "The content of the well should be an Assay or a Sample."
        } unless [Fluidigm::SAMPLE, Fluidigm::ASSAY].include?(type)

        location = index.to_i
        if size == Fluidigm::FLUIDIGM_96_96
          row = location/(number_of_columns/2)
          col_position = location % (number_of_columns/2)
          col = col_position - 1
          col += number_of_columns/2 if type == Fluidigm::SAMPLE && col_position > 0
          col -= number_of_columns/2 if type == Fluidigm::ASSAY && col_position == 0 && row > 0
        elsif size == Fluidigm::FLUIDIGM_192_24
          if type == Fluidigm::SAMPLE
            row = location/(number_of_rows-2)
            col = location % (number_of_rows-2)
            col = -1 if col == 0
          elsif type == Fluidigm::ASSAY
            col = is_assay_in_right_column?(location, Fluidigm::NUMBER_OF_ASSAY_IN_A_GROUP) ? 13 : 0
            row = (location / Fluidigm::NUMBER_OF_ASSAY_IN_A_GROUP) * 2
            row -= 1 if location % Fluidigm::NUMBER_OF_ASSAY_IN_A_GROUP == 0
          end
        else
          raise Fluidigm::InvalidSizeError, {
            "size" => "The number of rows/columns parameter is invalid."
          }
        end

        raise IndexOutOfRangeError unless (-1..number_of_rows).include?(row)

        # returns the location (row and column) in the container of the given assay/sample
        row*number_of_columns + col
      end

      # Returns the element name from the element's index
      # @param [Fixnum] index (stating at 0)
      # @return [String] ex "A1" or "S1"
      def index_to_element_name(index)
        if size == Fluidigm::FLUIDIGM_96_96
          row = index / number_of_columns
          column = index % (number_of_columns/2) + 1
          location = row * (number_of_columns/2) + column
          type = (index % number_of_columns >= number_of_columns/2) ? Fluidigm::SAMPLE : Fluidigm::ASSAY
        elsif size == Fluidigm::FLUIDIGM_192_24
          # assay at index location
          if is_assay_at_index(index)
            type = Fluidigm::ASSAY
            if is_assay_in_right_column?(index, number_of_columns)
              location = (index/number_of_columns) * (Fluidigm::NUMBER_OF_ASSAY_IN_A_GROUP.to_f/2) + 2
            else
              row = (index/number_of_columns)
              location = row + (row.to_f/2).ceil + 1
            end
          else
            # Sample at index location
            type = Fluidigm::SAMPLE
            row = index/number_of_columns
            column = index % number_of_columns
            location = row*(number_of_columns-2) + column
          end
        else
          raise Fluidigm::InvalidSizeError, {
            "size" => "The number of rows/columns parameter is invalid."
          }
        end

        # like "A3" if assay or "S4" if sample
        "#{type}#{location.to_i}"
      end

      def is_assay_at_index(index)
        is_assay_in_left_column?(index) || is_assay_in_right_column?(index, number_of_columns)
      end
      private :is_assay_at_index

      def is_assay_in_left_column?(index)
        index % number_of_columns == 0
      end
      private :is_assay_in_left_column?

      def is_assay_in_right_column?(index, number_of_columns)
        (index+1) % number_of_columns == 0
      end
      private :is_assay_in_right_column?

    end
  end
end
