require "requests/apiary/3_tube_resource/spec_helper"
describe "create_a_new_tube_with_sample_uuids", :tube => true do
  include_context "use core context service"
  it "create_a_new_tube_with_sample_uuids" do

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/tubes", <<-EOD
    {
    "tube": {
        "type": "Eppendorf",
        "max_volume": 2,
        "aliquots": [
            {
                "sample_uuid": "11111111-2222-3333-4444-666666666666",
                "type": "NA",
                "quantity": 5
            },
            {
                "sample_uuid": "11111111-2222-3333-4444-777777777777",
                "type": "NA",
                "quantity": 5
            }
        ]
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "tube": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "type": "Eppendorf",
        "max_volume": 2,
        "aliquots": [
            {
                "sample": {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                    },
                    "uuid": "11111111-2222-3333-4444-666666666666",
                    "name": "Sample 1"
                },
                "quantity": 5,
                "type": "NA",
                "unit": "mole"
            },
            {
                "sample": {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                        "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                        "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                        "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
                    },
                    "uuid": "11111111-2222-3333-4444-777777777777",
                    "name": "Sample 2"
                },
                "quantity": 5,
                "type": "NA",
                "unit": "mole"
            }
        ]
    }
}
    EOD

  end
end
