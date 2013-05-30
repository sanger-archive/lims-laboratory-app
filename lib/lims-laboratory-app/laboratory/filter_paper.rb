require 'lims-core/resource'
require 'lims-laboratory-app/laboratory/receptacle'
require 'lims-laboratory-app/laboratory/container'

module Lims::LaboratoryApp
  module Laboratory
    # Filter Paper is a labware which can contains samples.
    # It has a number of rows and columns. We call them locations.
    # Each locations can contains 0 or more different samples.
    # The filter paper can contains a barcode (either Sanger generated
    # or provided with the filter paper by an external company).
    class FilterPaper
      include Lims::Core::Resource
      include Container

      # A location is a Receptacle, which can contains 
      # 0 or more different samples
      class Location
        include Receptacle
      end

      is_matrix_of Location do |filter_paper, location|
        (filter_paper.number_of_rows * filter_paper.number_of_columns).times.map { location.new }
      end
    end
  end
end
