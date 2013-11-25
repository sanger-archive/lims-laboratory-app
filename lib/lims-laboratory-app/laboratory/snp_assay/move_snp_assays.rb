require 'lims-core/actions/action'
require 'lims-laboratory-app/laboratory/aliquot_content_shared'

module Lims::LaboratoryApp
  module Laboratory
    class SnpAssay

      class MoveSnpAssays
        include Lims::Core::Actions::Action
        include AliquotContentShared

        CONTENT_TYPE = "snp_assay"

        attribute :parameters, Array, :required => true, :writer => :private

        def _call_in_session(session)
          change_content(session, CONTENT_TYPE)
        end

      end
    end
  end
end
