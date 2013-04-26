require 'common'

require 'lims-laboratory-app/labels/labellable'

module Lims::LaboratoryApp
  module Labels
    class SangerBarcode
      include Labellable::Label
      Type = "sanger-barcode"
    end
  end
end
