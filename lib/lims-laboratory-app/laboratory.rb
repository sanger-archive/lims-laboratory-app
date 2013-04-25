#vi: ts=2 sw=2 et
require 'lims-laboratory-app/laboratory/plate.rb'
require 'lims-laboratory-app/laboratory/tube.rb'
require 'lims-laboratory-app/laboratory/flowcell.rb'

require 'lims-laboratory-app/laboratory/aliquot'
require 'lims-laboratory-app/laboratory/sample'
require 'lims-laboratory-app/laboratory/oligo'

module Lims::LaboratoryApp
  # Things used/found in the lab. Includes pure laboratory (inert things as {Plate plates}, {Tube tubes})
  # and chemical one (as {Aliquot aliquots}, {Sample samples}).
  module Laboratory
  end
end
