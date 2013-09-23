module Lims::LaboratoryApp
  module Laboratory
    class Sample
      module CreateSampleShared

        def create_sample(session, name, uuid)
          Laboratory::Sample.new(:name => name).tap do |sample|
            session << sample
            uuid_resource = session.new_uuid_resource_for(sample)
            uuid_resource.send(:uuid=, uuid)
          end
        end
      end
    end
  end
end
