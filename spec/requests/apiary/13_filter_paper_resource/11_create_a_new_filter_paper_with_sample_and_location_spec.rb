require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "create_a_new_filter_paper_with_sample_and_location", :filter_paper => true do
  include_context "use core context service"
  it "create_a_new_filter_paper_with_sample_and_location" do
  # **Create a new filter paper with a sample.**
    save_with_uuid Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1') => [1,2,3,4,6]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/filter_papers", <<-EOD
    {
    "filter_paper": {
        "aliquots": [
            {
                "sample_uuid": "11111111-2222-3333-4444-666666666666",
                "type": "DNA",
                "quantity": 2
            }
        ],
        "location": {
            "name": "ABC Hospital",
            "address": "CB11 2TY TubeCity 123 Sample Way",
            "internal": false
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "filter_paper": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555"
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
            "internal": false
        },
        "aliquots": [
            {
                "sample": {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "delete": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "create": "http://example.org/11111111-2222-3333-4444-666666666666"
                    },
                    "uuid": "11111111-2222-3333-4444-666666666666",
                    "name": "sample 1"
                },
                "quantity": 2,
                "type": "DNA",
                "unit": "mole"
            }
        ]
    }
}
    EOD

  end
end
