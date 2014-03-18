require "requests/apiary/5_spin_column_resource/spec_helper"
describe "create_a_new_empty_spin_with_location_column", :spin_column => true do
  include_context "use core context service"
  it "create_a_new_empty_spin_with_location_column" do
  # **Create a new empty spin column.**
    save_with_uuid Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1') => [1,2,3,4,6]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/spin_columns", <<-EOD
    {
    "spin_column": {
        "location": {
            "name": "ABC Hospital",
            "address": "CB11 2TY TubeCity 123 Sample Way"
        },
        "aliquots": [
            {
                "sample_uuid": "11111111-2222-3333-4444-666666666666",
                "type": "NA",
                "quantity": 5
            }
        ]
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "spin_column": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "location": {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
            },
            "uuid": "11111111-2222-3333-4444-777777777777",
            "name": "ABC Hospital",
            "address": "CB11 2TY TubeCity 123 Sample Way",
            "internal": true
        },
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
                    "name": "sample 1"
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
