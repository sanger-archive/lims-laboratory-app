require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "bulk_create_filter_paper", :filter_paper => true do
  include_context "use core context service"
  it "bulk_create_filter_paper" do
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 2')
    sample3 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 3')
    save_with_uuid sample1 => [1,2,3,4,0], sample2 => [1,2,3,4,1], sample3 => [1,2,3,4,2]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/bulk_create_filter_paper", <<-EOD
    {
    "bulk_create_filter_paper": {
        "filter_papers": [
            {
                "number_of_rows": 2,
                "number_of_columns": 2,
                "locations_description": {
                    "A1": [
                        {
                            "sample_uuid": "11111111-2222-3333-4444-000000000000"
                        }
                    ]
                }
            },
            {
                "number_of_rows": 2,
                "number_of_columns": 2,
                "locations_description": {
                    "A1": [
                        {
                            "sample_uuid": "11111111-2222-3333-4444-111111111111"
                        }
                    ]
                }
            },
            {
                "number_of_rows": 2,
                "number_of_columns": 2,
                "locations_description": {
                    "A1": [
                        {
                            "sample_uuid": "11111111-2222-3333-4444-222222222222"
                        }
                    ]
                }
            }
        ]
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "bulk_create_filter_paper": {
        "actions": {
        },
        "user": "user@example.com",
        "application": "application_id",
        "result": {
            "filter_papers": [
                {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "create": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                        "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
                    },
                    "uuid": "11111111-2222-3333-4444-555555555555",
                    "number_of_rows": 2,
                    "number_of_columns": 2,
                    "locations": {
                        "A1": [
                            {
                                "sample": {
                                    "actions": {
                                        "read": "http://example.org/11111111-2222-3333-4444-000000000000",
                                        "update": "http://example.org/11111111-2222-3333-4444-000000000000",
                                        "delete": "http://example.org/11111111-2222-3333-4444-000000000000",
                                        "create": "http://example.org/11111111-2222-3333-4444-000000000000"
                                    },
                                    "uuid": "11111111-2222-3333-4444-000000000000",
                                    "name": "sample 1"
                                },
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
                {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                        "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                    },
                    "uuid": "11111111-2222-3333-4444-666666666666",
                    "number_of_rows": 2,
                    "number_of_columns": 2,
                    "locations": {
                        "A1": [
                            {
                                "sample": {
                                    "actions": {
                                        "read": "http://example.org/11111111-2222-3333-4444-111111111111",
                                        "update": "http://example.org/11111111-2222-3333-4444-111111111111",
                                        "delete": "http://example.org/11111111-2222-3333-4444-111111111111",
                                        "create": "http://example.org/11111111-2222-3333-4444-111111111111"
                                    },
                                    "uuid": "11111111-2222-3333-4444-111111111111",
                                    "name": "sample 2"
                                },
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
                {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                        "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                        "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                        "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
                    },
                    "uuid": "11111111-2222-3333-4444-777777777777",
                    "number_of_rows": 2,
                    "number_of_columns": 2,
                    "locations": {
                        "A1": [
                            {
                                "sample": {
                                    "actions": {
                                        "read": "http://example.org/11111111-2222-3333-4444-222222222222",
                                        "update": "http://example.org/11111111-2222-3333-4444-222222222222",
                                        "delete": "http://example.org/11111111-2222-3333-4444-222222222222",
                                        "create": "http://example.org/11111111-2222-3333-4444-222222222222"
                                    },
                                    "uuid": "11111111-2222-3333-4444-222222222222",
                                    "name": "sample 3"
                                },
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
            ]
        },
        "filter_papers": [
            {
                "number_of_rows": 2,
                "number_of_columns": 2,
                "locations_description": {
                    "A1": [
                        {
                            "sample_uuid": "11111111-2222-3333-4444-000000000000"
                        }
                    ]
                }
            },
            {
                "number_of_rows": 2,
                "number_of_columns": 2,
                "locations_description": {
                    "A1": [
                        {
                            "sample_uuid": "11111111-2222-3333-4444-111111111111"
                        }
                    ]
                }
            },
            {
                "number_of_rows": 2,
                "number_of_columns": 2,
                "locations_description": {
                    "A1": [
                        {
                            "sample_uuid": "11111111-2222-3333-4444-222222222222"
                        }
                    ]
                }
            }
        ]
    }
}
    EOD

  end
end
