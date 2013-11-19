# Spec requirements
require 'models/spec_helper'
require 'models/laboratory/aliquot_shared'

# Model requirements

require 'lims-laboratory-app/laboratory/gel/all'
require 'lims-laboratory-app/laboratory/plate/all'
require 'lims-laboratory-app/laboratory/fluidigm/all'
require 'facets/array'

module Lims::LaboratoryApp
  module Laboratory
    shared_context "container-like asset factory" do
      include_context "aliquot factory"

      def new_plate_with_samples(sample_nb=5, volume=nil)
        new_container_with_samples(Plate, sample_nb, volume)
      end

      def new_gel_with_samples(sample_nb=5, volume=nil)
        new_container_with_samples(Gel, sample_nb, volume)
      end

      def new_fluidigm_with_samples(sample_nb=5, volume=nil)
        new_container_with_samples(Fluidigm, sample_nb, volume)
      end

      def new_container_with_samples(asset_to_create, sample_nb, volume=100, quantity=nil)
        asset_to_create.new(:number_of_rows => number_of_rows, :number_of_columns => number_of_columns).tap do |asset|
          unless asset_to_create == Fluidigm
            populate_general_container_with_samples(asset, sample_nb, volume, quantity)
          else
            populate_fluidigm(asset, sample_nb, volume, quantity)
          end
        end
      end

      def populate_general_container_with_samples(asset, sample_nb, volume, quantity)
        asset.each_with_index do |w, i|
          1.upto(sample_nb) do |j|
            w <<  new_aliquot(i,j,quantity)
          end
          w << Aliquot.new(:type => Aliquot::Solvent, :quantity => volume) if volume
        end
      end

      def populate_fluidigm(asset, sample_nb, volume, quantity)
        size = number_of_rows*number_of_columns
        # FLUIDIGM 96.96
        if size == 192
          0.upto(number_of_rows-1) do |row|
            1.upto(number_of_columns/2) do |column|
              index = row*number_of_columns/2 + column
              1.upto(sample_nb) do |j|
                asset["S#{index}"] << new_aliquot(index,j,quantity)
                asset["A#{index}"] << new_snp_assay_aliquot(index,j,quantity)
              end
            end
          end
        # FLUIDIGM 192.24
        elsif size == 224
          # TODO
        end
      end

      def new_empty_plate
        new_empty_container(Plate)
      end

      def new_empty_gel
        new_empty_container(Gel)
      end

      def new_empty_fluidigm
        new_empty_container(Fluidigm)
      end

      def new_empty_container(asset_to_create)
        asset_to_create.new(:number_of_rows => number_of_rows, :number_of_columns => number_of_columns)
      end

    end
  end
end
