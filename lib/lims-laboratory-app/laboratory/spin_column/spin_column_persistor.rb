# vi: ts=2:sts=2:et:sw=2 spell:spelllang=en


require 'lims-core/persistence/persistor'
require 'lims-laboratory-app/laboratory/spin_column'
require 'lims-laboratory-app/laboratory/aliquot/all'

module Lims::LaboratoryApp
  module Laboratory

    # Base for all SpinColumn persistor.
    # Real implementation classes (e.g. Sequel::SpinColumn) should
    # include the suitable persistor.
    class SpinColumn

      (does "lims/core/persistence/persistable",
        :children => [{:name => :spin_column_aliquot, :deletable => true }]
      ).class_eval do
        def children_spin_column_aliquot(resource, children)
          resource.each do |aliquot|
            children << SpinColumnPersistor::SpinColumnAliquot.new(resource, aliquot)
          end
        end

        association_class "SpinColumnAliquot" do
          attribute :spin_column, SpinColumn, :relation => :parent, :skip_parents_for_attributes => true
          attribute :aliquot, Aliquot, :relation => :parent

          def on_load
            @spin_column << @aliquot if @spin_column && @aliquot
          end

          def invalid?
            @aliquot && !@spin_column.include?(@aliquot)
          end

        end
      end
    end
  end
end
