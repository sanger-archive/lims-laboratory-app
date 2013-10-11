require "requests/apiary/4_tube_rack_resource/spec_helper"
describe "swap_samples_across_16_tubes_in_a_tube_rack", :tube_rack => true do
  include_context "use core context service"
  it "swap_samples_across_16_tubes_in_a_tube_rack" do
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample3 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample4 = Lims::LaboratoryApp::Laboratory::Sample.new
    
    sample5 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample6 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample7 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample8 = Lims::LaboratoryApp::Laboratory::Sample.new
    
    sample9 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample10 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample11 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample12 = Lims::LaboratoryApp::Laboratory::Sample.new
    
    sample13 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample14 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample15 = Lims::LaboratoryApp::Laboratory::Sample.new
    sample16 = Lims::LaboratoryApp::Laboratory::Sample.new
    
    tube1 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube1 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample1)
    tube2 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube2 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample2)
    tube3 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube3 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample3)
    tube4 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube4 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample4)
    
    tube5 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube5 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample5)
    tube6 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube6 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample6)
    tube7 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube7 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample7)
    tube8 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube8 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample8)
    
    tube9 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube9 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample9)
    tube10 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube10 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample10)
    tube11 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube11 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample11)
    tube12 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube12 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample12)
    
    tube13 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube13 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample13)
    tube14 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube14 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample14)
    tube15 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube15 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample15)
    tube16 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube16 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample16)
    
    rack = Lims::LaboratoryApp::Laboratory::TubeRack.new(:number_of_rows => 8, :number_of_columns => 12)
    rack["A1"] = tube1
    rack["A2"] = tube2
    rack["A3"] = tube3
    rack["A4"] = tube4
    rack["A5"] = tube5
    rack["A6"] = tube6
    rack["A7"] = tube7
    rack["A8"] = tube8
    rack["A9"] = tube9
    rack["A10"] = tube10
    rack["A11"] = tube11
    rack["A12"] = tube12
    rack["B1"] = tube13
    rack["B2"] = tube14
    rack["B3"] = tube15
    rack["B4"] = tube16
    
    save_with_uuid({
      rack => [1,2,3,5,6],
      sample1 => [1,2,3,0,1], sample2 => [1,2,3,0,2], sample3 => [1,2,3,0,3], sample4 => [1,2,3,0,4], 
      sample5 => [1,2,3,0,5], sample6 => [1,2,3,0,6], sample7 => [1,2,3,0,7], sample8 => [1,2,3,0,8], 
      sample9 => [1,2,3,0,9], sample10 => [1,2,3,1,0], sample11 => [1,2,3,1,1], sample12 => [1,2,3,1,2], 
      sample13 => [1,2,3,1,3], sample14 => [1,2,3,1,4], sample15 => [1,2,3,1,5], sample16 => [1,2,3,1,6], 
      tube1 => [1,0,0,0,1], tube2 => [1,0,0,0,2], tube3 => [1,0,0,0,3], tube4 => [1,0,0,0,4],
      tube5 => [1,0,0,0,5], tube6 => [1,0,0,0,6], tube7 => [1,0,0,0,7], tube8 => [1,0,0,0,8],
      tube9 => [1,0,0,0,9], tube10 => [1,0,0,1,0], tube11 => [1,0,0,1,1], tube12 => [1,0,0,1,2],
      tube13 => [1,0,0,1,3], tube14 => [1,0,0,1,4], tube15 => [1,0,0,1,5], tube16 => [1,0,0,1,6]
    })

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/swap_samples", <<-EOD
    {
    "swap_samples": {
        "parameters": [
            {
                "resource_uuid": "11111111-2222-3333-5555-666666666666",
                "swaps": {
                    "11111111-2222-3333-0000-111111111111": "11111111-2222-3333-0000-444444444444",
                    "11111111-2222-3333-0000-222222222222": "11111111-2222-3333-0000-333333333333",
                    "11111111-2222-3333-0000-333333333333": "11111111-2222-3333-0000-222222222222",
                    "11111111-2222-3333-0000-444444444444": "11111111-2222-3333-0000-111111111111",
                    "11111111-2222-3333-0000-555555555555": "11111111-2222-3333-0000-888888888888",
                    "11111111-2222-3333-0000-666666666666": "11111111-2222-3333-0000-777777777777",
                    "11111111-2222-3333-0000-777777777777": "11111111-2222-3333-0000-666666666666",
                    "11111111-2222-3333-0000-888888888888": "11111111-2222-3333-0000-555555555555",
                    "11111111-2222-3333-0000-999999999999": "11111111-2222-3333-1111-222222222222",
                    "11111111-2222-3333-1111-000000000000": "11111111-2222-3333-1111-111111111111",
                    "11111111-2222-3333-1111-111111111111": "11111111-2222-3333-1111-000000000000",
                    "11111111-2222-3333-1111-222222222222": "11111111-2222-3333-0000-999999999999",
                    "11111111-2222-3333-1111-333333333333": "11111111-2222-3333-1111-666666666666",
                    "11111111-2222-3333-1111-444444444444": "11111111-2222-3333-1111-555555555555",
                    "11111111-2222-3333-1111-555555555555": "11111111-2222-3333-1111-444444444444",
                    "11111111-2222-3333-1111-666666666666": "11111111-2222-3333-1111-333333333333"
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
        "result": [
            {
                "tube_rack": {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-5555-666666666666",
                        "create": "http://example.org/11111111-2222-3333-5555-666666666666",
                        "update": "http://example.org/11111111-2222-3333-5555-666666666666",
                        "delete": "http://example.org/11111111-2222-3333-5555-666666666666"
                    },
                    "uuid": "11111111-2222-3333-5555-666666666666",
                    "number_of_rows": 8,
                    "number_of_columns": 12,
                    "tubes": {
                        "A1": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-111111111111",
                                "create": "http://example.org/11111111-0000-0000-0000-111111111111",
                                "update": "http://example.org/11111111-0000-0000-0000-111111111111",
                                "delete": "http://example.org/11111111-0000-0000-0000-111111111111"
                            },
                            "uuid": "11111111-0000-0000-0000-111111111111",
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
                                }
                            ]
                        },
                        "A2": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-222222222222",
                                "create": "http://example.org/11111111-0000-0000-0000-222222222222",
                                "update": "http://example.org/11111111-0000-0000-0000-222222222222",
                                "delete": "http://example.org/11111111-0000-0000-0000-222222222222"
                            },
                            "uuid": "11111111-0000-0000-0000-222222222222",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
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
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A3": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-333333333333",
                                "create": "http://example.org/11111111-0000-0000-0000-333333333333",
                                "update": "http://example.org/11111111-0000-0000-0000-333333333333",
                                "delete": "http://example.org/11111111-0000-0000-0000-333333333333"
                            },
                            "uuid": "11111111-0000-0000-0000-333333333333",
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
                                }
                            ]
                        },
                        "A4": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-444444444444",
                                "create": "http://example.org/11111111-0000-0000-0000-444444444444",
                                "update": "http://example.org/11111111-0000-0000-0000-444444444444",
                                "delete": "http://example.org/11111111-0000-0000-0000-444444444444"
                            },
                            "uuid": "11111111-0000-0000-0000-444444444444",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
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
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A5": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-555555555555",
                                "create": "http://example.org/11111111-0000-0000-0000-555555555555",
                                "update": "http://example.org/11111111-0000-0000-0000-555555555555",
                                "delete": "http://example.org/11111111-0000-0000-0000-555555555555"
                            },
                            "uuid": "11111111-0000-0000-0000-555555555555",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-0000-888888888888",
                                            "create": "http://example.org/11111111-2222-3333-0000-888888888888",
                                            "update": "http://example.org/11111111-2222-3333-0000-888888888888",
                                            "delete": "http://example.org/11111111-2222-3333-0000-888888888888"
                                        },
                                        "uuid": "11111111-2222-3333-0000-888888888888",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A6": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-666666666666",
                                "create": "http://example.org/11111111-0000-0000-0000-666666666666",
                                "update": "http://example.org/11111111-0000-0000-0000-666666666666",
                                "delete": "http://example.org/11111111-0000-0000-0000-666666666666"
                            },
                            "uuid": "11111111-0000-0000-0000-666666666666",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-0000-777777777777",
                                            "create": "http://example.org/11111111-2222-3333-0000-777777777777",
                                            "update": "http://example.org/11111111-2222-3333-0000-777777777777",
                                            "delete": "http://example.org/11111111-2222-3333-0000-777777777777"
                                        },
                                        "uuid": "11111111-2222-3333-0000-777777777777",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A7": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-777777777777",
                                "create": "http://example.org/11111111-0000-0000-0000-777777777777",
                                "update": "http://example.org/11111111-0000-0000-0000-777777777777",
                                "delete": "http://example.org/11111111-0000-0000-0000-777777777777"
                            },
                            "uuid": "11111111-0000-0000-0000-777777777777",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-0000-666666666666",
                                            "create": "http://example.org/11111111-2222-3333-0000-666666666666",
                                            "update": "http://example.org/11111111-2222-3333-0000-666666666666",
                                            "delete": "http://example.org/11111111-2222-3333-0000-666666666666"
                                        },
                                        "uuid": "11111111-2222-3333-0000-666666666666",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A8": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-888888888888",
                                "create": "http://example.org/11111111-0000-0000-0000-888888888888",
                                "update": "http://example.org/11111111-0000-0000-0000-888888888888",
                                "delete": "http://example.org/11111111-0000-0000-0000-888888888888"
                            },
                            "uuid": "11111111-0000-0000-0000-888888888888",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-0000-555555555555",
                                            "create": "http://example.org/11111111-2222-3333-0000-555555555555",
                                            "update": "http://example.org/11111111-2222-3333-0000-555555555555",
                                            "delete": "http://example.org/11111111-2222-3333-0000-555555555555"
                                        },
                                        "uuid": "11111111-2222-3333-0000-555555555555",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A9": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-0000-999999999999",
                                "create": "http://example.org/11111111-0000-0000-0000-999999999999",
                                "update": "http://example.org/11111111-0000-0000-0000-999999999999",
                                "delete": "http://example.org/11111111-0000-0000-0000-999999999999"
                            },
                            "uuid": "11111111-0000-0000-0000-999999999999",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-1111-222222222222",
                                            "create": "http://example.org/11111111-2222-3333-1111-222222222222",
                                            "update": "http://example.org/11111111-2222-3333-1111-222222222222",
                                            "delete": "http://example.org/11111111-2222-3333-1111-222222222222"
                                        },
                                        "uuid": "11111111-2222-3333-1111-222222222222",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A10": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-1111-000000000000",
                                "create": "http://example.org/11111111-0000-0000-1111-000000000000",
                                "update": "http://example.org/11111111-0000-0000-1111-000000000000",
                                "delete": "http://example.org/11111111-0000-0000-1111-000000000000"
                            },
                            "uuid": "11111111-0000-0000-1111-000000000000",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-1111-111111111111",
                                            "create": "http://example.org/11111111-2222-3333-1111-111111111111",
                                            "update": "http://example.org/11111111-2222-3333-1111-111111111111",
                                            "delete": "http://example.org/11111111-2222-3333-1111-111111111111"
                                        },
                                        "uuid": "11111111-2222-3333-1111-111111111111",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A11": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-1111-111111111111",
                                "create": "http://example.org/11111111-0000-0000-1111-111111111111",
                                "update": "http://example.org/11111111-0000-0000-1111-111111111111",
                                "delete": "http://example.org/11111111-0000-0000-1111-111111111111"
                            },
                            "uuid": "11111111-0000-0000-1111-111111111111",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-1111-000000000000",
                                            "create": "http://example.org/11111111-2222-3333-1111-000000000000",
                                            "update": "http://example.org/11111111-2222-3333-1111-000000000000",
                                            "delete": "http://example.org/11111111-2222-3333-1111-000000000000"
                                        },
                                        "uuid": "11111111-2222-3333-1111-000000000000",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "A12": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-1111-222222222222",
                                "create": "http://example.org/11111111-0000-0000-1111-222222222222",
                                "update": "http://example.org/11111111-0000-0000-1111-222222222222",
                                "delete": "http://example.org/11111111-0000-0000-1111-222222222222"
                            },
                            "uuid": "11111111-0000-0000-1111-222222222222",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-0000-999999999999",
                                            "create": "http://example.org/11111111-2222-3333-0000-999999999999",
                                            "update": "http://example.org/11111111-2222-3333-0000-999999999999",
                                            "delete": "http://example.org/11111111-2222-3333-0000-999999999999"
                                        },
                                        "uuid": "11111111-2222-3333-0000-999999999999",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "B1": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-1111-333333333333",
                                "create": "http://example.org/11111111-0000-0000-1111-333333333333",
                                "update": "http://example.org/11111111-0000-0000-1111-333333333333",
                                "delete": "http://example.org/11111111-0000-0000-1111-333333333333"
                            },
                            "uuid": "11111111-0000-0000-1111-333333333333",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-1111-666666666666",
                                            "create": "http://example.org/11111111-2222-3333-1111-666666666666",
                                            "update": "http://example.org/11111111-2222-3333-1111-666666666666",
                                            "delete": "http://example.org/11111111-2222-3333-1111-666666666666"
                                        },
                                        "uuid": "11111111-2222-3333-1111-666666666666",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "B2": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-1111-444444444444",
                                "create": "http://example.org/11111111-0000-0000-1111-444444444444",
                                "update": "http://example.org/11111111-0000-0000-1111-444444444444",
                                "delete": "http://example.org/11111111-0000-0000-1111-444444444444"
                            },
                            "uuid": "11111111-0000-0000-1111-444444444444",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-1111-555555555555",
                                            "create": "http://example.org/11111111-2222-3333-1111-555555555555",
                                            "update": "http://example.org/11111111-2222-3333-1111-555555555555",
                                            "delete": "http://example.org/11111111-2222-3333-1111-555555555555"
                                        },
                                        "uuid": "11111111-2222-3333-1111-555555555555",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "B3": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-1111-555555555555",
                                "create": "http://example.org/11111111-0000-0000-1111-555555555555",
                                "update": "http://example.org/11111111-0000-0000-1111-555555555555",
                                "delete": "http://example.org/11111111-0000-0000-1111-555555555555"
                            },
                            "uuid": "11111111-0000-0000-1111-555555555555",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-1111-444444444444",
                                            "create": "http://example.org/11111111-2222-3333-1111-444444444444",
                                            "update": "http://example.org/11111111-2222-3333-1111-444444444444",
                                            "delete": "http://example.org/11111111-2222-3333-1111-444444444444"
                                        },
                                        "uuid": "11111111-2222-3333-1111-444444444444",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        },
                        "B4": {
                            "actions": {
                                "read": "http://example.org/11111111-0000-0000-1111-666666666666",
                                "create": "http://example.org/11111111-0000-0000-1111-666666666666",
                                "update": "http://example.org/11111111-0000-0000-1111-666666666666",
                                "delete": "http://example.org/11111111-0000-0000-1111-666666666666"
                            },
                            "uuid": "11111111-0000-0000-1111-666666666666",
                            "type": null,
                            "max_volume": null,
                            "aliquots": [
                                {
                                    "sample": {
                                        "actions": {
                                            "read": "http://example.org/11111111-2222-3333-1111-333333333333",
                                            "create": "http://example.org/11111111-2222-3333-1111-333333333333",
                                            "update": "http://example.org/11111111-2222-3333-1111-333333333333",
                                            "delete": "http://example.org/11111111-2222-3333-1111-333333333333"
                                        },
                                        "uuid": "11111111-2222-3333-1111-333333333333",
                                        "name": null
                                    },
                                    "quantity": 10,
                                    "type": "DNA",
                                    "unit": "mole"
                                }
                            ]
                        }
                    }
                }
            }
        ],
        "parameters": [
            {
                "resource_uuid": "11111111-2222-3333-5555-666666666666",
                "swaps": {
                    "11111111-2222-3333-0000-111111111111": "11111111-2222-3333-0000-444444444444",
                    "11111111-2222-3333-0000-222222222222": "11111111-2222-3333-0000-333333333333",
                    "11111111-2222-3333-0000-333333333333": "11111111-2222-3333-0000-222222222222",
                    "11111111-2222-3333-0000-444444444444": "11111111-2222-3333-0000-111111111111",
                    "11111111-2222-3333-0000-555555555555": "11111111-2222-3333-0000-888888888888",
                    "11111111-2222-3333-0000-666666666666": "11111111-2222-3333-0000-777777777777",
                    "11111111-2222-3333-0000-777777777777": "11111111-2222-3333-0000-666666666666",
                    "11111111-2222-3333-0000-888888888888": "11111111-2222-3333-0000-555555555555",
                    "11111111-2222-3333-0000-999999999999": "11111111-2222-3333-1111-222222222222",
                    "11111111-2222-3333-1111-000000000000": "11111111-2222-3333-1111-111111111111",
                    "11111111-2222-3333-1111-111111111111": "11111111-2222-3333-1111-000000000000",
                    "11111111-2222-3333-1111-222222222222": "11111111-2222-3333-0000-999999999999",
                    "11111111-2222-3333-1111-333333333333": "11111111-2222-3333-1111-666666666666",
                    "11111111-2222-3333-1111-444444444444": "11111111-2222-3333-1111-555555555555",
                    "11111111-2222-3333-1111-555555555555": "11111111-2222-3333-1111-444444444444",
                    "11111111-2222-3333-1111-666666666666": "11111111-2222-3333-1111-333333333333"
                }
            }
        ]
    }
}
    EOD

  end
end
