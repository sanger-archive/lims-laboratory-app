# Spec requirements
require 'models/persistence/sequel/spec_helper'

require 'models/laboratory/flowcell_shared'
require 'models/laboratory/location_shared'
require 'models/persistence/resource_shared'
require 'models/persistence/sequel/store_shared'
require 'models/persistence/sequel/page_shared'
require 'models/persistence/filter/multi_criteria_sequel_filter_shared'

# Model requirements
require 'lims-core/persistence/sequel/store'
require 'lims-laboratory-app/laboratory/flowcell/all'

module Lims::LaboratoryApp
  shared_context "already created flowcell" do
    let(:aliquot) { new_aliquot }
    before (:each) do
      store.with_session { |session| session << new_empty_flowcell.tap {|_| _[0] << aliquot} }
    end
    let(:flowcell_id) { store.with_session { |session| @flowcell_id = last_flowcell_id(session) } }

    context "when modified within a session" do
      before do
        store.with_session do |s|
          flowcell = s.flowcell[flowcell_id]
          flowcell[0].clear
          flowcell[1]<< aliquot
        end
      end
      it "should be saved" do
        store.with_session do |session|
          f = session.flowcell[flowcell_id]
          f[7].empty_resource?.should be_true
          f[1].should == [aliquot]
          f[0].empty_resource?.should be_true
        end
      end
    end
    context "when modified outside a session" do
      before do
        flowcell = store.with_session do |s|
          s.flowcell[flowcell_id]
        end
        flowcell[0].clear
        flowcell[1]<< aliquot
      end
      it "should not be saved" do
        store.with_session do |session|
          f = session.flowcell[flowcell_id]
          f[7].empty_resource?.should be_true
          f[1].empty_resource?.should be_true
          f[0].should == [aliquot]
        end
      end
    end
  end

  shared_context "with a location" do
    it "can be saved and reloaded" do
      flowcell_id = save(subject)

      store.with_session do |session|
        flowcell = session.flowcell[flowcell_id]
        flowcell.location.should == location
      end
    end
  end

  describe "Sequel#Flowcell ", :flowcell => true, :laboratory => true, :persistence => true, :sequel => true do
    include_context "sequel store"
    let(:hiseq_number_of_lanes) { 8 }
    let(:miseq_number_of_lanes) { 1 }

    include_context "flowcell factory"
    include_context "define location"

    def last_flowcell_id(session)
      session.flowcell.dataset.order_by(:id).last[:id]
    end

    # execute tests with miseq flowcell
    context "miseql"  do
    let(:number_of_lanes) { miseq_number_of_lanes }
      subject { new_flowcell_with_samples(3) }
      it_behaves_like "storable resource", :flowcell, {:flowcells => 1, :lanes => 1*3 }

      pending "only works for hiseq"  do
        include_context "already created flowcell"
      end

      include_context "with a location"
    end

    # execute tests with hiseq flowcell
    context "hiseq"  do
    let(:number_of_lanes) { hiseq_number_of_lanes }

      subject { new_flowcell_with_samples(3) }
      it_behaves_like "storable resource", :flowcell, {:flowcells => 1, :lanes => 8*3 }
      include_context "already created flowcell"
      include_context "with a location"
    end

    context do
    let(:number_of_lanes) { hiseq_number_of_lanes }
    let(:constructor) { lambda { |*_| new_flowcell_with_samples } }
    it_behaves_like "paginable resource", :flowcell
    it_behaves_like "filtrable", :flowcell
    end
  end
end
