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

      does "lims/core/persistence/persistable", :children => [
        {:name => :tube_aliquot, :deletable => true }
      ]
      class TubePersistor
        def children_tube_aliquot(resource, children)
          resource.each do |aliquot|
            children << TubeAliquot.new(resource, aliquot)
          end
        end

        class TubeAliquot
          include Lims::Core::Resource
          attribute :tube, Tube, :relation => :parent
          attribute :aliquot, Aliquot, :relation => :parent
          does "lims/core/persistence/persist_association", TubePersistor

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
