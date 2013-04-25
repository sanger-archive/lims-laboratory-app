require 'common'

require 'lims-core/labels/labellable'

module Lims::LaboratoryApp
  module Labels
    class SangerBarcode
      include Labellable::Label
      Type = "sanger-barcode"
    end
  end
end
