require "requests/apiary/4_tube_rack_resource/spec_helper"
describe "swap_samples_across_2_tubes_with_2_samples_in_each_in_a_tube_rack", :tube_rack => true do
  include_context "use core context service"
  it "swap_samples_across_2_tubes_with_2_samples_in_each_in_a_tube_rack" do
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample3 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample4 = Lims::LaboratoryApp::Laboratory::Sample.new
    
    tube1 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube1 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample1)
    tube1 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "RNA", :sample => sample2)
    
    tube2 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube2 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample3)
    tube2 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "RNA", :sample => sample4)
    
    rack = Lims::LaboratoryApp::Laboratory::TubeRack.new(:number_of_rows => 8, :number_of_columns => 12)
    rack["A1"] = tube1
    rack["B2"] = tube2
    
    save_with_uuid({
      sample1 => [1,2,3,0,1], sample2 => [1,2,3,0,2], sample3 => [1,2,3,0,3], sample4 => [1,2,3,0,4], 
      tube1 => [1,2,3,1,1], tube2 => [1,2,3,1,2],
      rack => [1,2,3,2,1]
    })

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/swap_samples", <<-EOD
    {
    "swap_samples": {
        "parameters": [
            {
                "resource_uuid": "11111111-2222-3333-2222-111111111111",
                "swaps": {
                    "11111111-2222-3333-0000-111111111111": "11111111-2222-3333-0000-444444444444",
                    "11111111-2222-3333-0000-222222222222": "11111111-2222-3333-0000-333333333333",
                    "11111111-2222-3333-0000-333333333333": "11111111-2222-3333-0000-222222222222",
                    "11111111-2222-3333-0000-444444444444": "11111111-2222-3333-0000-111111111111"
                }
            }
        ]
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "swap_samples": {
        "actions": {
        },
        "user": "user",
        "application": "application",
        "result": {
            "resources": [
                {
                    "tube_rack": {
                        "actions": {
                            "read": "http://example.org/11111111-2222-3333-2222-111111111111",
                            "create": "http://example.org/11111111-2222-3333-2222-111111111111",
                            "update": "http://example.org/11111111-2222-3333-2222-111111111111",
                            "delete": "http://example.org/11111111-2222-3333-2222-111111111111"
                        },
                        "uuid": "11111111-2222-3333-2222-111111111111",
                        "number_of_rows": 8,
                        "number_of_columns": 12,
                        "tubes": {
                            "A1": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-1111-111111111111",
                                    "create": "http://example.org/11111111-2222-3333-1111-111111111111",
                                    "update": "http://example.org/11111111-2222-3333-1111-111111111111",
                                    "delete": "http://example.org/11111111-2222-3333-1111-111111111111"
                                },
                                "uuid": "11111111-2222-3333-1111-111111111111",
                                "type": null,
                                "max_volume": null,
                                "aliquots": [
                                    {
                                        "sample": {
                                            "actions": {
                                                "read": "http://example.org/11111111-2222-3333-0000-444444444444",
                                                "create": "http://example.org/11111111-2222-3333-0000-444444444444",
                                                "update": "http://example.org/11111111-2222-3333-0000-444444444444",
                                                "delete": "http://example.org/11111111-2222-3333-0000-444444444444"
                                            },
                                            "uuid": "11111111-2222-3333-0000-444444444444",
                                            "name": null
                                        },
                                        "quantity": 10,
                                        "type": "DNA",
                                        "unit": "mole"
                                    },
                                    {
                                        "sample": {
                                            "actions": {
                                                "read": "http://example.org/11111111-2222-3333-0000-333333333333",
                                                "create": "http://example.org/11111111-2222-3333-0000-333333333333",
                                                "update": "http://example.org/11111111-2222-3333-0000-333333333333",
                                                "delete": "http://example.org/11111111-2222-3333-0000-333333333333"
                                            },
                                            "uuid": "11111111-2222-3333-0000-333333333333",
                                            "name": null
                                        },
                                        "quantity": 10,
                                        "type": "RNA",
                                        "unit": "mole"
                                    }
                                ]
                            },
                            "B2": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-1111-222222222222",
                                    "create": "http://example.org/11111111-2222-3333-1111-222222222222",
                                    "update": "http://example.org/11111111-2222-3333-1111-222222222222",
                                    "delete": "http://example.org/11111111-2222-3333-1111-222222222222"
                                },
                                "uuid": "11111111-2222-3333-1111-222222222222",
                                "type": null,
                                "max_volume": null,
                                "aliquots": [
                                    {
                                        "sample": {
                                            "actions": {
                                                "read": "http://example.org/11111111-2222-3333-0000-222222222222",
                                                "create": "http://example.org/11111111-2222-3333-0000-222222222222",
                                                "update": "http://example.org/11111111-2222-3333-0000-222222222222",
                                                "delete": "http://example.org/11111111-2222-3333-0000-222222222222"
                                            },
                                            "uuid": "11111111-2222-3333-0000-222222222222",
                                            "name": null
                                        },
                                        "quantity": 10,
                                        "type": "DNA",
                                        "unit": "mole"
                                    },
                                    {
                                        "sample": {
                                            "actions": {
                                                "read": "http://example.org/11111111-2222-3333-0000-111111111111",
                                                "create": "http://example.org/11111111-2222-3333-0000-111111111111",
                                                "update": "http://example.org/11111111-2222-3333-0000-111111111111",
                                                "delete": "http://example.org/11111111-2222-3333-0000-111111111111"
                                            },
                                            "uuid": "11111111-2222-3333-0000-111111111111",
                                            "name": null
                                        },
                                        "quantity": 10,
                                        "type": "RNA",
                                        "unit": "mole"
                                    }
                                ]
                            }
                        }
                    }
                }
            ]
        },
        "parameters": [
            {
                "resource_uuid": "11111111-2222-3333-2222-111111111111",
                "swaps": {
                    "11111111-2222-3333-0000-111111111111": "11111111-2222-3333-0000-444444444444",
                    "11111111-2222-3333-0000-222222222222": "11111111-2222-3333-0000-333333333333",
                    "11111111-2222-3333-0000-333333333333": "11111111-2222-3333-0000-222222222222",
                    "11111111-2222-3333-0000-444444444444": "11111111-2222-3333-0000-111111111111"
                }
            }
        ]
    }
}
    EOD

  end
end
