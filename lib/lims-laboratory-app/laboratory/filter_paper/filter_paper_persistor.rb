require 'lims-core/persistence/persist_association_trait'
require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/aliquot/all'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper

      (does "lims/core/persistence/persistable",
        :parents => [:location],
        :children => [{:name => :filter_paper_aliquot, :deletable => true}
      ]).class_eval do

        def children_filter_paper_aliquot(resource, children)
          resource.each do |aliquot|
            children << FilterPaperPersistor::FilterPaperAliquot.new(resource, aliquot)
          end
        end

        association_class "FilterPaperAliquot" do
          attribute :filter_paper, FilterPaper, :relation => :parent, :skip_parents_for_attributes => true
          attribute :aliquot, Aliquot, :relation => :parent

          def on_load
            @filter_paper << @aliquot if @filter_paper && @aliquot
          end

          def invalid?
            @aliquot && !@filter_paper.include?(@aliquot)
          end
        end
      end
    end
  end
end
