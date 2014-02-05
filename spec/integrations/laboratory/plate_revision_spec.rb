
require 'integrations/laboratory/spec_helper'

require 'lims-api/context_service'
require 'lims-core'
require 'lims-core/persistence/sequel'

require 'integrations/laboratory/lab_resource_shared'
require 'integrations/laboratory/resource_shared'
require 'models/laboratory/container_like_asset_shared'
require 'models/persistence/sequel/spec_helper'

require 'lims-core/persistence/sequel/user_session_sequel_persistor'


module Lims::LaboratoryApp
  describe "#plate revision" do
    include_context "use core context service"
    include_context "use generated uuid"
    let(:model) { "plates" }
    let(:location) { nil }

    def get_last_session_id
      store.database[:sessions].max(:id)
    end

    def for_session(session_id)
      store.with_session do |session|
        Lims::Core::Persistence::Sequel::Revision::Session.new(store, session_id).with_session do |revision|

          yield(revision)
        end
      end
    end

    context "with existing plate" do
      # Set default dimension to create a plate
      let(:number_of_rows) { 1 }
      let(:number_of_columns) { 2 }
      include_context "container-like asset factory"
      let!(:plate_id) { save(new_plate_with_samples) }
      let!(:session_id0) { get_last_session_id }
      # /!\ The order of those let is IMPORTANT
      let!(:plate1) { store.with_session do |session|
          session.plate[plate_id].tap do |plate|
            plate.type = 'new type'
          end
        end
      }
      let!(:session_id1)  { plate1; get_last_session_id }
      let!(:plate2) {
        session_id1
        store.with_session do |session|
          session.plate[plate_id].tap do |plate|
            plate[0].clear
          end
        end
      }
      let!(:session_id2)  { plate2; get_last_session_id }
      it do 
        # create plates revision

        for_session(session_id0) do |session|
          plate = session.plate[plate_id]
          plate.type.should be_nil
        end

        for_session(session_id1) do |session|
          plate = session.plate[plate_id]

          plate.should == plate1

          plate.type.should == 'new type'
        end

        for_session(session_id2) do |session|
          plate = session.plate[plate_id]

          plate.should == plate2

          plate.type.should == 'new type'
        end
      end
    end
  end
end
