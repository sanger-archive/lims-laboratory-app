# Spec requirements
require 'models/persistence/sequel/spec_helper'
require 'models/persistence/sequel/store_shared'
require 'models/persistence/resource_shared'

# Model requirements
require 'lims-laboratory-app/organization/location'
require 'lims-laboratory-app/organization/location/location_persistor'

module Lims::LaboratoryApp
  describe Organization::Location, :organization => true,  :persistence => true, :sequel => true  do
    include_context "sequel store"

    def last_location_id(session)
      session.location.dataset.order_by(:id).last[:id]
    end

    
    let(:name)      { "ABC Hospital" }
    let(:new_name)  { "DEF Institute" }
    let(:address)   { "CB99 5RT SampleCity 123 Sample Way" }
    let(:internal)  { false }
    subject { Organization::Location.new( :name => name,
                            :address => address,
                            :internal => internal)
    }

    context "create a location" do
      it_behaves_like "storable resource", :location, {:locations => 1 }
    end

    context "already created location" do
      before(:each) do
        store.with_session { |session| session << Organization::Location.new( :name => name,
          :address => address,
          :internal => internal) }
      end
      let!(:location_id) { store.with_session { |session| @location_id = last_location_id(session) } }

      context "when modified within a session" do
        before do
          store.with_session do |s|
            location = s.location[location_id]
            location.name = new_name
          end
        end
        it "should be saved" do
          store.with_session do |session|
            l = session.location[location_id]
            l.should be_a(Organization::Location)
          end
        end
      end
      context "when modified outside a session" do
        before do
          location = store.with_session do |s|
            s.location[location_id]
          end
          location.name = new_name
        end
        it "should not be saved" do
          store.with_session do |session|
            location = session.location[location_id]
            location.name.should_not == new_name
          end
        end
      end
      context "should be deletable" do
        def delete_location
          store.with_session do |session|
            location = session.location[location_id]
            session.delete(location)
          end
        end

        it "deletes the location row" do
          expect { delete_location }.to change { db[:locations].count}.by(-1)
        end
      end
    end
  end
end
