require 'common'
require 'lims-laboratory-app/labels/labellable'

module Lims::LaboratoryApp
  module Labels
    class EAN13Barcode
      include Labellable::Label
      Type = "ean13-barcode"
    end
  end
end
