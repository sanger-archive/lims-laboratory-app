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

      # creates the matrix of container elements (Windows)
      matrix_of(:Window)
    end
  end
end
