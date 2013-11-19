require 'lims-laboratory-app/laboratory/filter_paper'
require 'lims-laboratory-app/laboratory/create_labellable_resource_action'
require 'lims-laboratory-app/laboratory/sample/create_sample_shared'

module Lims::LaboratoryApp
  module Laboratory
    class FilterPaper
      class CreateFilterPaper
        include CreateLabellableResourceAction
        include Laboratory::Sample::CreateSampleShared

        attribute :aliquots, Array, :default => []

        def initialize(*args, &block)
          @name = "Create Filter Paper"
          super(*args, &block)
        end

        # TODO : to refactor with create_tube
        def create(session)
          filter_paper = Laboratory::FilterPaper.new
          session << filter_paper
          count = 1
          if aliquots
            aliquots.each do |aliquot|
              # The sample uuid comes from lims-management-app, 
              # as a result, the sample is not present in the 
              # lims-laboratory-app sample table. The following 
              # creates a new sample with the expected uuid.
              aliquot_ready = aliquot.mash do |k,v|
                case k.to_s
                when "sample_uuid" then 
                  count += 1
                  ["sample", create_sample(session, "Sample #{count}", v)] 
                else 
                  [k,v]
                end
              end
              filter_paper << Laboratory::Aliquot.new(aliquot_ready)
            end
          end
          {:filter_paper => filter_paper, :uuid => session.uuid_for!(filter_paper)}
        end
      end

      Create = CreateFilterPaper
    end
  end
end
