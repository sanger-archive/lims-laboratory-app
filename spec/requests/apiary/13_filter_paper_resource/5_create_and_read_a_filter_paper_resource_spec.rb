require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "create_and_read_a_filter_paper_resource", :filter_paper => true do
  include_context "use core context service"
  it "create_and_read_a_filter_paper_resource" do


  # **Use the create filter paper action.**
  # * `number_of_rows` number of rows of the filter paper
  # * `number_of_columns` number of columns of the filter paper
  # * `locations_description` map aliquots to locations
    save_with_uuid Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1') => [1,2,3,4,6]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/create_filter_paper", <<-EOD
    {
    "create_filter_paper": {
        "number_of_rows": 2,
        "number_of_columns": 2,
        "locations_description": {
            "A1": [
                {
                    "sample": "11111111-2222-3333-4444-666666666666",
                    "type": "DNA",
                    "quantity": 2
                }
            ]
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "create_filter_paper": {
        "actions": {
        },
        "user": "user",
        "application": "application",
        "result": {
            "filter_paper": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555"
                },
                "uuid": "11111111-2222-3333-4444-555555555555",
                "number_of_rows": 2,
                "number_of_columns": 2,
                "locations": {
                    "A1": [
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
                            "quantity": 2,
                            "type": "DNA",
                            "unit": "mole"
                        }
                    ],
                    "A2": [

                    ],
                    "B1": [

                    ],
                    "B2": [

                    ]
                }
            },
            "uuid": "11111111-2222-3333-4444-555555555555"
        },
        "labels": null,
        "number_of_rows": 2,
        "number_of_columns": 2,
        "locations_description": {
            "A1": [
                {
                    "sample": "11111111-2222-3333-4444-666666666666",
                    "type": "DNA",
                    "quantity": 2
                }
            ]
        }
    }
}
    EOD

  # **Reads the previously created filter paper.**

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/11111111-2222-3333-4444-555555555555"
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
        "number_of_rows": 2,
        "number_of_columns": 2,
        "locations": {
            "A1": [
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
                    "quantity": 2,
                    "type": "DNA",
                    "unit": "mole"
                }
            ],
            "A2": [

            ],
            "B1": [

            ],
            "B2": [

            ]
        }
    }
}
    EOD

  end
end
