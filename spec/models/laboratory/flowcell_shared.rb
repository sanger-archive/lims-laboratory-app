# Spec requirements
require 'models/spec_helper'

# Model requirements

require 'lims-laboratory-app/laboratory/flowcell'
require 'facets/array'

module Lims::LaboratoryApp
  module Laboratory
    shared_context "flowcell factory" do
      def new_flowcell_with_samples(sample_nb=5)
        Flowcell.new(
          :number_of_lanes => number_of_lanes,
          :location => location
        ).tap do |flowcell|
          flowcell.each_with_index do |lane, i|
            1.upto(sample_nb) do |j|
              lane <<  new_aliquot(i,j)
            end
          end
        end
      end

      def new_empty_flowcell
        Flowcell.new(:number_of_lanes => number_of_lanes, :location => location)
      end

      def new_sample(i=1, j=1)
        Sample.new(["Sample", i, j].compact.conjoin(" ", "/"))
      end

      def new_aliquot(i=nil, j=nil)
        sample = Sample
          Aliquot.new(:sample => new_sample(i,j))
      end

    end

    shared_context "has number of lane" do |nb_of_lanes|
      let(:number_of_lanes) { nb_of_lanes }
      let(:number_of_lanes_hash) { { :number_of_lanes => number_of_lanes } }
    end

    shared_context "miseq flowcell" do
      include_context("has number of lane", 1)
    end

    shared_context "hiseq flowcell" do
      include_context("has number of lane", 8)
    end
  end
end
