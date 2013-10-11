require 'lims-laboratory-app/laboratory/filter_paper'

require 'models/laboratory/located_examples'
require 'models/laboratory/container_examples'
require 'models/labels/labellable_examples'
require 'models/laboratory/receptacle_examples'

module Lims::LaboratoryApp::Laboratory
  shared_examples "a valid filter paper" do
    it_behaves_like "located" 
    context "contains locations" do
      it_behaves_like "a container", FilterPaper::Location
    end
  end

  describe FilterPaper do
    # define the parameter related variables
    let(:number_of_rows) { 3 }
    let(:number_of_columns) { 3 }
    let(:size) { number_of_rows * number_of_columns }
    let(:parameters) { {
      :number_of_rows     => number_of_rows,
      :number_of_columns  => number_of_columns
    } }

    # define the container (Location) related variables
    let(:container) { FilterPaper::Location }
    let(:error_container_does_not_exists) { FilterPaper::IndexOutOfRangeError }

    context "filter paper with 2 rows and 2 columns" do
      subject {
        described_class.new(parameters)
      }

      its(:number_of_rows) { should == number_of_rows }
      its(:number_of_columns) { should == number_of_columns }
      its(:size) { should = size }

      it_behaves_like "a valid filter paper"
      it_behaves_like "a hash"
      it_behaves_like "labellable"
    end
  end

  describe FilterPaper::Location do
    it_behaves_like "receptacle"
  end
end
