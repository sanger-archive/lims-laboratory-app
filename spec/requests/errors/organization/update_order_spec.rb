require "requests/errors/organization/spec_helper"
describe "update_order" do
  include_context "use core context service"
  it "update_order" do
  # Updating an order should check uuid format
    study = Lims::LaboratoryApp::Organization::Study.new
    user = Lims::LaboratoryApp::Organization::User.new(:email => 'user@example.com')
    order = Lims::LaboratoryApp::Organization::Order.new(:creator => user, :study => study, :pipeline => "P1", :cost_code => "cost code")
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    batch = Lims::LaboratoryApp::Organization::Batch.new(:process => "manual extraction")
    item = Lims::LaboratoryApp::Organization::Order::Item.new(:uuid =>  "11111111-2222-3333-4444-666666666666")
    
    order.add_item("role1", item)
    save_with_uuid study => [1,1,1,1,1],
      user => [1,1,1,1,0],
      order => [1,2,3,4,5],
      tube => [1,2,3,4,6],
      batch => [1,2,3,4,7]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = put "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
    "items": {
        "role1": {
            "111111112-222-3333-4444-666666666666": {
                "event": "start"
            }
        }
    }
}
    EOD
    response.should match_json_response(422, <<-EOD) 
    {
    "errors": {
        "role": "Item index '111111112-222-3333-4444-666666666666' not a valid uuid or number for role 'role1'"
    }
}
    EOD

  end
end
