require "requests/apiary/17_shipping_request_resource/spec_helper"
describe "use_the_create_shipping_request_action", :shipping_request => true do
  include_context "use core context service"
  it "use_the_create_shipping_request_action" do
  # **Use the create shipping request action.**
  # 
  #  `name` the UUID of the labware
  # * `location` the location data of the labware
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    location = Lims::LaboratoryApp::Organization::Location.new(
        :name     => "ABC Hospital",
        :address  => "CB11 3DF Cambridge 123 Sample Way",
        :internal => false)
    
    save_with_uuid tube => [1,2,3,4,0], location => [1,2,3,3,0]
    location 

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/create_shipping_request", <<-EOD
    {
    "create_shipping_request": {
        "name": "11111111-2222-3333-4444-000000000000",
        "location_uuid": "11111111-2222-3333-3333-000000000000"
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "create_shipping_request": {
        "actions": {
        },
        "user": "user@example.com",
        "application": "application_id",
        "result": {
            "shipping_request": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555"
                },
                "uuid": "11111111-2222-3333-4444-555555555555",
                "name": "11111111-2222-3333-4444-000000000000",
                "location": {
                    "name": "ABC Hospital",
                    "address": "CB11 3DF Cambridge 123 Sample Way",
                    "internal": false
                }
            },
            "uuid": "11111111-2222-3333-4444-555555555555"
        },
        "name": "11111111-2222-3333-4444-000000000000",
        "location_uuid": "11111111-2222-3333-3333-000000000000"
    }
}
    EOD

  end
end
