require "requests/apiary/11_flowcell_resource/spec_helper"
describe "create_a_new_empty_flowcell", :flowcell => true do
  include_context "use core context service"
  it "create_a_new_empty_flowcell" do
  # **Create an flowcell resource.**
  # 
  # * `number_of_lanes` the number of lanes the flowcell has.

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/flowcells", <<-EOD
    {
    "flowcell": {
        "number_of_lanes": 8
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "flowcell": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "location": null,
        "number_of_lanes": 8,
        "lanes": {
            "1": [

            ],
            "2": [

            ],
            "3": [

            ],
            "4": [

            ],
            "5": [

            ],
            "6": [

            ],
            "7": [

            ],
            "8": [

            ]
        }
    }
}
    EOD

  end
end
