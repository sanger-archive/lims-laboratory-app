require 'lims-laboratory-app/laboratory/filter_paper/all'

module Lims::LaboratoryApp
  module Laboratory
    shared_context "filter paper factory" do
      def new_filter_paper_with_samples(sample_nb=5, quantity=100, volume=100)
        FilterPaper.new.tap do |filter_paper|
          1.upto(sample_nb) do |i|
            filter_paper <<  new_aliquot(quantity, i)
          end
          filter_paper << L::Aliquot.new(:type => L::Aliquot::Solvent, :quantity => volume) if volume
        end
      end

      def new_empty_filter_paper
        SpinColumn.new
      end
    end
  end
end
