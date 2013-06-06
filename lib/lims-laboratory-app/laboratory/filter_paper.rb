require 'lims-core/resource'
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
      extend Lims::LaboratoryApp::Laboratory::Container

      # creates the matrix of container elements (Locations)
      matrix_of(:Location)
    end
  end
end
