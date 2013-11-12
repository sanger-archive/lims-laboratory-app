require 'lims-laboratory-app/laboratory/sample'
require 'lims-laboratory-app/laboratory/aliquot'
require 'lims-laboratory-app/laboratory/allele'
require 'lims-laboratory-app/laboratory/assay'

module Lims::LaboratoryApp
  module Laboratory
    shared_context "aliquot factory" do
      def new_sample(i=1, j=1)
        Sample.new(create_name("Sample", i, j))
      end

      def new_assay(row=1, col=1)
        allele_x = Allele::A
        allele_y = Allele::G
        Assay.new(:name => create_name("Assay", row, col),
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
    end
  end
end

