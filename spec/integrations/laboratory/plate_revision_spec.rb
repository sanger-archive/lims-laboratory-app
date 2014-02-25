
require 'integrations/laboratory/spec_helper'

require 'lims-api/context_service'
require 'lims-core'
require 'lims-core/persistence/sequel'

require 'integrations/laboratory/lab_resource_shared'
require 'integrations/laboratory/resource_shared'
require 'models/laboratory/container_like_asset_shared'
require 'models/persistence/sequel/spec_helper'

require 'lims-core/persistence/sequel/user_session_sequel_persistor'

shared_examples "retrieving direct revisions" do
  it do
    store.with_session do |session|
      user_session = Lims::Core::Persistence::UserSession.new(:id => session_id, :parent_session => session)
      revisions = user_session.direct_revisions
      got = revisions.map { |r| { :id => r.id, :action => r.action, :model => r.model.name.split('::').last.snakecase} }
      got.sort_by { |h| h.inspect}.should == expected.sort_by { |h| h.inspect}
    end
  end
end

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
      let!(:aliquot_id) {
        store.with_session do |session|
          aliquot_ids = []
          session.plate[plate_id].each do |well|
            well.each do |aliquot|
              aliquot_ids << session.aliquot.id_for(aliquot)
            end
          end
          aliquot_ids.min
        end
      }
      let!(:well_aliquot_id) { 
        store.with_session do |session|
          session.plate.well_aliquot.dataset.select(:id).where(:aliquot_id => aliquot_id).first[:id]
        end
      } # Hack !!!
      let!(:sample_id) {
        store.with_session do |session|
          sample_ids = []
          session.plate[plate_id].each do |well|
            well.each do |aliquot|
              sample_ids << session.sample.id_for(aliquot.sample)
            end
          end
          sample_ids.min
        end
      }
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
            # clear first well containing 5 aliquots and 5 samples
            plate[0].clear
          end
        end
      }
      let!(:session_id2)  { plate2; get_last_session_id }
      let!(:plate3) {
        session_id1
        store.with_session do |session|
          session.plate[plate_id].tap do |plate|
            # clear first well containing 5 aliquots and 5 samples
            plate[1].first.quantity = 5
          end
        end
      }
      let!(:session_id3)  { plate3; get_last_session_id }
      it "can load plate state for a given session_id" do 
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
        for_session(session_id3) do |session|
          plate = session.plate[plate_id]

          plate.should_not == plate2
          plate.should == plate3
        end
      end

      it "can find all revisions modifying the plate" do
        store.with_session do |session|
          plate = session.plate[plate_id]
          sessions = session.user_session.for_resources(plate)
          sessions.map {|s| s.id }.should == [session_id0, session_id1, session_id2, session_id3]
        end
      end
      context "for a specific revision" do
        context "retrieves direct resources" do

          context "session 0" do
            let(:session_id) { session_id0 }
            let(:expected) {[
                {:id => plate_id, :action=> "insert", :model => "plate"},
                {:id => well_aliquot_id, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+1, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+2, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+3, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+4, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+5, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+6, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+7, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+8, :action=> "insert", :model => "well_aliquot"},
                {:id => well_aliquot_id+9, :action=> "insert", :model => "well_aliquot"},
                {:id => aliquot_id, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+1, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+2, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+3, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+4, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+5, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+6, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+7, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+8, :action=> "insert", :model => "aliquot"},
                {:id => aliquot_id+9, :action=> "insert", :model => "aliquot"},
                {:id => sample_id+0, :action=> "insert", :model => "sample"},
                {:id => sample_id+1, :action=> "insert", :model => "sample"},
                {:id => sample_id+2, :action=> "insert", :model => "sample"},
                {:id => sample_id+3, :action=> "insert", :model => "sample"},
                {:id => sample_id+4, :action=> "insert", :model => "sample"},
                {:id => sample_id+5, :action=> "insert", :model => "sample"},
                {:id => sample_id+6, :action=> "insert", :model => "sample"},
                {:id => sample_id+7, :action=> "insert", :model => "sample"},
                {:id => sample_id+8, :action=> "insert", :model => "sample"},
                {:id => sample_id+9, :action=> "insert", :model => "sample"},
              ]
            }
            it_behaves_like "retrieving direct revisions"
          end
          context "session 1" do
            let(:session_id) { session_id1 }
            let(:expected) {[
                {:id => plate_id, :action=> "update", :model => "plate"},
              ]
            }
            it_behaves_like "retrieving direct revisions"
          end
          context "session 2" do
            let(:session_id) { session_id2 }
            let(:expected) {[
                {:id => well_aliquot_id+0, :action=> "delete", :model => "well_aliquot"},
                {:id => well_aliquot_id+1, :action=> "delete", :model => "well_aliquot"},
                {:id => well_aliquot_id+2, :action=> "delete", :model => "well_aliquot"},
                {:id => well_aliquot_id+3, :action=> "delete", :model => "well_aliquot"},
                {:id => well_aliquot_id+4, :action=> "delete", :model => "well_aliquot"},
                {:id => aliquot_id+0, :action=> "delete", :model => "aliquot"},
                {:id => aliquot_id+1, :action=> "delete", :model => "aliquot"},
                {:id => aliquot_id+2, :action=> "delete", :model => "aliquot"},
                {:id => aliquot_id+3, :action=> "delete", :model => "aliquot"},
                {:id => aliquot_id+4, :action=> "delete", :model => "aliquot"},
              ]
            }
            it_behaves_like "retrieving direct revisions"
          end
          context "session 3" do
            let(:session_id) { session_id3 }
            let(:expected) {[
                {:id => aliquot_id+5, :action=> "update", :model => "aliquot"},
              ]
            }
            it_behaves_like "retrieving direct revisions"
          end
        end

        context "retrieves all resources" do
          #it_behaves_like "retrieving all modified resources", session_id0, [[:name, 1], [:plate, plate_id]]
          #it_behaves_like "retrieving all modified resources", session_id1, [[:name, 1], [:plate, plate_id]]
          #it_behaves_like "retrieving all modified resources", session_id2, [[:name, 1], [:plate, plate_id]]
          #it_behaves_like "retrieving all modified resources", session_id3, [[:name, 2], [:plate, plate_id]]
        end
      end

    end
  end
end
