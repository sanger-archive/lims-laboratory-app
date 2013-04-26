require 'common'

require 'lims-laboratory-app/labels/labellable'

module Lims::LaboratoryApp
  module Labels
    class Barcode2D
      include Labellable::Label
      Type = "2d-barcode"
    end
  end
end
