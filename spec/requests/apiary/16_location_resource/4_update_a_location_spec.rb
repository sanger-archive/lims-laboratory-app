require "requests/apiary/16_location_resource/spec_helper"
describe "update_a_location" do
  include_context "use core context service"
  it "update_a_location" do
  # **Update a location resource.**
  # 
  # * `name` name of the location
  # * `address` the address of the location
  # * `internal` a boolean value. True if the labware is internal, otherwise false.
    location = Lims::LaboratoryApp::Organization::Location.new(
        :name => 'ABC Hospital',
        :address => 'CB11 3DF Cambridge 123 Sample Way',
        :internal => false
    )
    save_with_uuid location => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = put "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
    "name": "new ABC Hospital",
    "address": "new CB11 3DF Cambridge 123 Sample Way",
    "internal": true
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "location": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "name": "new ABC Hospital",
        "address": "new CB11 3DF Cambridge 123 Sample Way",
        "internal": true
    }
}
    EOD

  end
end
