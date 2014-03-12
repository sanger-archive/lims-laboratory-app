require "requests/apiary/11_flowcell_resource/spec_helper"
describe "create_a_new_flowcell_with_samples", :flowcell => true do
  include_context "use core context service"
  it "create_a_new_flowcell_with_samples" do
  # **Create a new flowcell with samples.**
  # 
  # * `number_of_lanes` number of lanes the flowcell has.
  # * `lanes` map aliquots to lane locations
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 2')
    save_with_uuid sample1 => [1,2,3,4,6], sample2 => [1,2,3,4,7]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/flowcells", <<-EOD
    {
    "flowcell": {
        "number_of_lanes": 8,
        "lanes_description": {
            "2": [
                {
                    "sample_uuid": "11111111-2222-3333-4444-666666666666",
                    "type": "DNA",
                    "quantity": 10
                }
            ],
            "5": [
                {
                    "sample_uuid": "11111111-2222-3333-4444-777777777777",
                    "type": "DNA",
                    "quantity": 10
                }
            ]
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "flowcell": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "number_of_lanes": 8,
        "location": null,
        "lanes": {
            "1": [

            ],
            "2": [
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
                    "quantity": 10,
                    "type": "DNA",
                    "unit": "mole"
                }
            ],
            "3": [

            ],
            "4": [

            ],
            "5": [
                {
                    "sample": {
                        "actions": {
                            "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "delete": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "create": "http://example.org/11111111-2222-3333-4444-777777777777"
                        },
                        "uuid": "11111111-2222-3333-4444-777777777777",
                        "name": "sample 2"
                    },
                    "quantity": 10,
                    "type": "DNA",
                    "unit": "mole"
                }
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
