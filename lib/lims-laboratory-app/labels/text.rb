require 'lims-laboratory-app/labels/labellable'

module Lims::LaboratoryApp
  module Labels
    class Text
      include Labellable::Label
      Type = "text"
    end
  end
end
