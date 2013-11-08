require 'lims-laboratory-app/laboratory/assay'
require 'lims-core/actions/action'

module Lims::LaboratoryApp
  module Laboratory
    class Assay
      class CreateAssay
        include Lims::Core::Actions::Action

        attribute :name, String, :required => true
        attribute :allele_x, Allele, :required => true
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
