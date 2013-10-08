require 'lims-core/actions/bulk_action'
require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/filter_paper/create_filter_paper'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class BulkCreateFilterPaper
        include Lims::Core::Actions::BulkAction
        initialize_class(:filter_paper, :filter_papers, CreateFilterPaper)
      end
    end
  end
end
