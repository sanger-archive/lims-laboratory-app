# Spec requirements
require 'models/spec_helper'
require 'models/laboratory/aliquot_shared'

# Model requirements

require 'lims-laboratory-app/laboratory/tube_rack/all'
require 'facets/array'

module Lims::LaboratoryApp
  module Laboratory
    shared_context "tube_rack factory" do
      include_context "aliquot factory"

      def new_tube_rack_with_samples(sample_nb=5, quantity=nil, volume=100)
        TubeRack.new(:number_of_rows => number_of_rows, :number_of_columns => number_of_columns).tap do |tube_rack|
          tube_rack.each_with_index do |slot, i|
            tube = Tube.new
            tube_rack[i] = tube
            1.upto(sample_nb) do |j|
              tube <<  new_aliquot(i,j,quantity)
            end
            tube << Aliquot.new(:type => Aliquot::Solvent, :quantity => volume) if volume
          end
        end
      end

      def new_empty_tube_rack()
        TubeRack.new(:number_of_rows => number_of_rows, :number_of_columns => number_of_columns)
      end

      def new_empty_tube()
        Tube.new
      end

    end
  end
end
