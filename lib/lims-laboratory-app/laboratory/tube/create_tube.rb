# vi: ts=2:sts=2:et:sw=2  spell:spelllang=en  
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/create_receptacle_action_trait'

module Lims::LaboratoryApp
  module Laboratory
    class Tube
      class CreateTube

        does "lims/laboratory_app/laboratory/receptacle/create_receptacle_action", {
          :receptacle_name => "tube",
          :receptacle_class => Laboratory::Tube,
          :extra_parameters => [:type, :max_volume]
        }

        attribute :type, String, :required => false
        attribute :max_volume, Numeric, :required => false

      end
    end
  end
  module Laboratory
    class Tube
      Create = CreateTube
    end
  end
end
