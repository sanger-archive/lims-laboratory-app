require 'lims-laboratory-app/laboratory/spin_column'
require 'lims-laboratory-app/laboratory/create_receptacle_action_trait'

module Lims::LaboratoryApp
  module Laboratory
    class SpinColumn
      class CreateSpinColumn

        does "lims/laboratory_app/laboratory/receptacle/create_receptacle_action", {
          :receptacle_name => "spin_column",
          :receptacle_class => Laboratory::SpinColumn
        }

      end
    end
  end

  module Laboratory
    class SpinColumn
      Create = CreateSpinColumn
    end
  end
end
