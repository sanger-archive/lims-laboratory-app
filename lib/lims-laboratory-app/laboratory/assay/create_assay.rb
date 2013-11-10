require 'lims-laboratory-app/laboratory/assay'
require 'lims-core/actions/action'

module Lims::LaboratoryApp
  module Laboratory
    class Assay
      # This class creates an instance of a assay.
      class CreateAssay
        include Lims::Core::Actions::Action

        # name of the assay
        attribute :name, String, :required => true
        # x allele of the assay (can be A, C, G or T)
        attribute :allele_x, Allele, :required => true
        # y allele of the assay (can be A, C, G or T)
        attribute :allele_y, Allele, :required => true

        def _call_in_session(session)
          assay = Laboratory::Assay.new(:name     => name, 
                                :allele_x => allele_x, 
                                :allele_y => allele_y)
          session << assay

          { :assay => assay, :uuid => session.uuid_for!(assay) }
        end
      end

      Create = CreateAssay

    end
  end
end
