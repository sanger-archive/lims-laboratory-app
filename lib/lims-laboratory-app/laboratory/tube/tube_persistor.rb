# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en

require 'lims-core/persistence/persist_association_trait'
require 'lims-laboratory-app/laboratory/tube'
require 'lims-laboratory-app/laboratory/aliquot/all'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all Tube persistor.
    # Real implementation classes (e.g. Sequel::Tube) should
    # include the suitable persistor.
    class Tube
      (does "lims/core/persistence/persistable", :children => [
        {:name => :tube_aliquot, :deletable => true }
      ]).class_eval do
        def children_tube_aliquot(resource, children)
          resource.each do |aliquot|
            children << TubePersistor::TubeAliquot.new(resource, aliquot)
          end
        end

        association_class "TubeAliquot" do
          attribute :tube, Tube, :relation => :parent, :skip_parents_for_attributes => true
          attribute :aliquot, Aliquot, :relation => :parent

          def on_load
            @tube << @aliquot if @tube && @aliquot
          end

          def invalid?
            @aliquot && !@tube.include?(@aliquot)
          end

        end
      end
    end
  end
end

require 'lims-laboratory-app/laboratory/tube_rack/all'
