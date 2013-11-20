require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/create_receptacle_action_trait'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class CreateFilterPaper

        does "lims/laboratory_app/laboratory/receptacle/create_receptacle_action", {
          :receptacle_name => "filter_paper",
          :receptacle_class => Laboratory::FilterPaper
        }

      end

      Create = CreateFilterPaper
    end
  end
end
