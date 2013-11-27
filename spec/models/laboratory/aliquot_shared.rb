require 'lims-laboratory-app/laboratory/sample'
require 'lims-laboratory-app/laboratory/aliquot'
require 'lims-laboratory-app/laboratory/allele'
require 'lims-laboratory-app/laboratory/snp_assay'

module Lims::LaboratoryApp
  module Laboratory
    shared_context "aliquot factory" do
      def new_sample(i=1, j=1)
        Sample.new(create_name("Sample", i, j))
      end

      def new_snp_assay(row=1, col=1)
        allele_x = Allele::A
        allele_y = Allele::G
        SnpAssay.new(:name => create_name("SnpAssay", row, col),
                  :allele_x => allele_x,
                  :allele_y => allele_y)
      end

      def create_name(name, i, j)
        [name, i, j].compact.conjoin(" ", "/")
      end

      def new_aliquot(i=nil, j=nil, q=nil)
        aliquot = Aliquot.new(:sample => new_sample(i,j))
        aliquot.quantity = q if q
        aliquot
      end

      def new_snp_assay_aliquot(i=nil, j=nil, q=nil)
        aliquot = Aliquot.new(:snp_assay => new_snp_assay(i,j))
        aliquot.quantity = q if q
        aliquot
      end
    end
  end
end

