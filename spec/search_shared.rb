require 'lims-core/persistence/search/all'



shared_context "with saved assets" do 
  let!(:asset_ids) do
    store.with_session do |session|
      asset_uuids.map do |uuid|
        new_asset = asset_type.new(asset_parameters)                
        set_uuid(session, new_asset, uuid)
        lambda { session.id_for(new_asset) }
      end
    end.map { |l| l.call }
  end
end


shared_context "with saved labels" do
  let(:labellable_type) { "resource" }
  let(:label_position) { "front barcode" }
  let(:label_type) { "sanger-barcode" }

  let(:labellable_uuids) {
    (0..asset_uuids.size).map { |i| "22221111-2222-3333-4444-88888888888#{i}" }
  }
  let!(:labellable_ids) {
    store.with_session do |session|
      asset_uuids.zip(labellable_uuids) do |asset_uuid, labellable_uuid|
        labellable = Lims::LaboratoryApp::Labels::Labellable.new(:name => asset_uuid, :type => labellable_type)
        labellable[label_position] = Lims::LaboratoryApp::Labels::SangerBarcode.new(:value => asset_uuid)
        set_uuid(session, labellable, labellable_uuid)
      end
    end
  }
end


shared_context "with saved orders" do
  include_context "with saved batches"
  let(:basic_parameters) { {:creator => Lims::LaboratoryApp::Organization::User.new, :study => Lims::LaboratoryApp::Organization::Study.new} }
  let(:orders) { {
    "99999999-1111-0000-0000-000000000000" => 
    Lims::LaboratoryApp::Organization::Order.new(basic_parameters.merge(:pipeline => "P1")).tap do |o|
      o.add_source("source1", "11111111-1111-0000-0000-000000000000")
      o.add_source("source2", "11111111-1111-0000-0000-000000000001")
      o.add_target("target1", "11111111-1111-0000-0000-000000000002")
      o.build!
      o.start!
    end,
    "99999999-2222-0000-0000-000000000000" => 
    Lims::LaboratoryApp::Organization::Order.new(basic_parameters.merge(:pipeline => "P2")).tap do |o|
      o.add_source("source1", "11111111-1111-0000-0000-000000000001")
      o.add_source("source2", "11111111-1111-0000-0000-000000000003")
      o.add_target("target3", "11111111-1111-0000-0000-000000000004")
      o.build!
    end,
    "99999999-3333-0000-0000-000000000000" => 
    Lims::LaboratoryApp::Organization::Order.new(basic_parameters.merge(:pipeline => "P3")).tap do |o|
      o.add_source("source1", "11111111-1111-0000-0000-000000000000")
      o.add_source("source3", "11111111-1111-0000-0000-000000000001")
      o.add_target("target2", "11111111-1111-0000-0000-000000000002")
      o.build!
      o.start!
    end
  } }

  let!(:uuids) {
    store.with_session do |session|
      orders.each do |uuid, order|
        set_uuid(session, order, uuid)
        order[:source2].first.batch = session[batch_uuids[0]] if order.pipeline == 'P1'
        order[:source1].first.batch = session[batch_uuids[1]] if order.pipeline == 'P2'
        order[:target2].first.batch = session[batch_uuids[0]] if order.pipeline == 'P3'
      end
    end
  }
end

shared_context "with saved batches" do
  let!(:batch_uuids) do
    ['11111111-2222-2222-3333-000000000000', '11111111-2222-2222-3333-111111111111'].tap do |uuids|
      uuids.each do |uuid|
        store.with_session do |session|
          batch = Lims::LaboratoryApp::Organization::Batch.new
          session << batch
          ur = session.new_uuid_resource_for(batch)
          ur.send(:uuid=, uuid)
        end
      end
    end
  end
end

