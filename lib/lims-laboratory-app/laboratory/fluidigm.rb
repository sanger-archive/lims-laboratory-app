require 'lims-laboratory-app/laboratory/locatable_resource'
require 'lims-laboratory-app/laboratory/container'

require 'facets/hash'
require 'facets/array'

module Lims::LaboratoryApp
  module Laboratory
    # Fluidigm is a labware as seen in the laboratory.
    # It has a number of rows and number of columns property.
    # It is a rectangular bit of plastic and contains Wells for SNP Assay and Samples.
    # It can have a layout of 96 SNP Assay wells and 96 Sample wells or
    # 192 Samples wells and 24 SNP Assay wells.
    # It can has some readable labels on it (i.e. barcode).
    class Fluidigm
      include LocatableResource

      FLUIDIGM_96_96  = 12*16
      FLUIDIGM_192_24 = 14*16
      NUMBER_OF_ASSAY_IN_A_GROUP = 3
      ASSAY           = 'A'
      SAMPLE          = 'S'

      InvalidElementNameError = Class.new(Lims::Core::Actions::Action::InvalidParameters)
      InvalidSizeError = Class.new(Lims::Core::Actions::Action::InvalidParameters)

      # creates the matrix of container elements (Wells),
      # which contains some chemical substances.
      matrix_of(:Well)

      # Converts an element name to indexes and call super,
      # which will convert these indexes to an index of the underlying container.
      # The result could be from 0 to size - 1
      # @param [String/Fixnum] type of the content (sample/snp_assay) if it is a String
      # or the row location if it is a Fixnum
      # @param [Fixnum] location (starting from 1)
      # @return [Fixnum] index could be from 0 to size - 1
      def element_name_to_index(row_string, column_string)
        if row_string.is_a?(String)
          raise Fluidigm::InvalidElementNameError, {
            "content" => "The content of the well should be an Assay or a Sample."
          } unless [Fluidigm::SAMPLE, Fluidigm::ASSAY].include?(row_string)

          column_string = column_string.to_i
          if size == Fluidigm::FLUIDIGM_96_96
            row     = (column_string - 1)/(number_of_columns/2)
            column  = (column_string - 1)%(number_of_columns/2)
            column += number_of_columns/2 if row_string == Fluidigm::SAMPLE
          elsif size == Fluidigm::FLUIDIGM_192_24
            if row_string == Fluidigm::SAMPLE
              column_location = column_string%(number_of_columns-2)
              row = column_string/(number_of_columns-2)
              row -= 1 if column_location == 0
              column = column_location == 0 ? 12 : column_location
            elsif row_string == Fluidigm::ASSAY
              row = (column_string / Fluidigm::NUMBER_OF_ASSAY_IN_A_GROUP) * 2
              row -= 1 if column_string % Fluidigm::NUMBER_OF_ASSAY_IN_A_GROUP == 0
              column = is_assay_in_right_column?(column_string, Fluidigm::NUMBER_OF_ASSAY_IN_A_GROUP) ? 13 : 0
            end
          end
        else
          row = row_string
          column = column_string
        end

        # calling super with the calculated row and column indexes
        # A1 -> like (0,0)
        super(row, column)
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

      # Checks if the content is a snp_assay at index
      def is_assay_at_index(index)
        is_assay_in_left_column?(index) || is_assay_in_right_column?(index, number_of_columns)
      end
      private :is_assay_at_index

      # Checks if the index location is in the left column
      def is_assay_in_left_column?(index)
        index % number_of_columns == 0
      end
      private :is_assay_in_left_column?

      # Checks if the index location is in the right column
      def is_assay_in_right_column?(index, number_of_columns)
        (index+1) % number_of_columns == 0
      end
      private :is_assay_in_right_column?

    end
  end
end
