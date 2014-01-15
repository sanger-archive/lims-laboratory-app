require "requests/apiary/16_location_resource/spec_helper"
describe "bulk_update_labwares_location" do
  include_context "use core context service"
  it "bulk_update_labwares_location" do


  # **Bulk update the location of labwares.**
  # 
  # * `name` name of the location
  # * `address` the address of the location
  # * `internal` a boolean value. True if the labware is internal, otherwise false.
  # * `labware_uuids` an array of labware uuids to update
    location = Lims::LaboratoryApp::Organization::Location.new(
        :name => 'ABC Hospital',
        :address => 'CB11 3DF Cambridge 123 Sample Way',
        :internal => false
    )
    tube1 = Lims::LaboratoryApp::Laboratory::Tube.new(:location => location)
    tube2 = Lims::LaboratoryApp::Laboratory::Tube.new(:location => location)
    tube3 = Lims::LaboratoryApp::Laboratory::Tube.new(:location => location)
    save_with_uuid location => [1,2,3,4,5], tube1 => [1,1,3,4,5], tube2 => [1,1,3,4,6], tube3 => [1,1,3,4,7]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = put "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
    "name": "new ABC Hospital",
    "address": "new CB11 3DF Cambridge 123 Sample Way",
    "internal": true,
    "labware_uuids": [
        "11111111-1111-3333-4444-555555555555",
        "11111111-1111-3333-4444-666666666666",
        "11111111-1111-3333-4444-777777777777"
    ]
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

  # Read the updated labware

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/11111111-1111-3333-4444-555555555555"
    response.should match_json_response(200, <<-EOD) 
    {
    "tube": {
        "actions": {
            "read": "http://example.org/11111111-1111-3333-4444-555555555555",
            "create": "http://example.org/11111111-1111-3333-4444-555555555555",
            "update": "http://example.org/11111111-1111-3333-4444-555555555555",
            "delete": "http://example.org/11111111-1111-3333-4444-555555555555"
        },
        "uuid": "11111111-1111-3333-4444-555555555555",
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
        },
        "type": null,
        "max_volume": null,
        "aliquots": [

        ]
    }
}
    EOD

  end
end
