require 'lims-laboratory-app/laboratory/snp_assay'
require 'lims-core/actions/action'

module Lims::LaboratoryApp
  module Laboratory
    class SnpAssay
      # This class creates an instance of a assay.
      class CreateSnpAssay
        include Lims::Core::Actions::Action

        # name of the snp_assay
        attribute :name, String, :required => true
        # x allele of the snp_assay (can be A, C, G or T)
        attribute :allele_x, String, :required => true
        # y allele of the snp_assay (can be A, C, G or T)
        attribute :allele_y, String, :required => true

        def _call_in_session(session)
          snp_assay = Laboratory::SnpAssay.new( :name => name,
                                                :allele_x => allele_x,
                                                :allele_y => allele_y)
          session << snp_assay

          { :snp_assay => snp_assay, :uuid => session.uuid_for!(snp_assay) }
        end
      end

      Create = CreateSnpAssay

    end
  end
end
