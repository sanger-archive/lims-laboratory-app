require "requests/apiary/4_tube_rack_resource/spec_helper"
describe "update_a_tube_rack_with_solvent_volume", :tube_rack => true do
  include_context "use core context service"
  it "update_a_tube_rack_with_solvent_volume" do
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    source_tube1 = Lims::LaboratoryApp::Laboratory::Tube.new << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 5, :type => "NA", :sample => sample1)
    tube_rack = Lims::LaboratoryApp::Laboratory::TubeRack.new(:number_of_columns => 12, :number_of_rows => 8)
    tube_rack["A1"] = source_tube1
    
    new_tube1 = Lims::LaboratoryApp::Laboratory::Tube.new
    
    save_with_uuid({
      sample1 => [1,2,3,0,0],
      source_tube1 => [1,2,3,4,5], tube_rack => [1,2,3,4,7],
      new_tube1 => [1,2,4,5,3]
    })

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = put "/11111111-2222-3333-4444-777777777777", <<-EOD
    {
    "tubes": {
        "A1": {
            "tube_uuid": "11111111-2222-3333-4444-555555555555",
            "volume": 10
        },
        "G10": {
            "tube_uuid": "11111111-2222-4444-5555-333333333333",
            "volume": 20
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "tube_rack": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-777777777777",
            "create": "http://example.org/11111111-2222-3333-4444-777777777777",
            "update": "http://example.org/11111111-2222-3333-4444-777777777777",
            "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
        },
        "uuid": "11111111-2222-3333-4444-777777777777",
        "number_of_rows": 8,
        "number_of_columns": 12,
        "tubes": {
            "A1": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
                },
                "uuid": "11111111-2222-3333-4444-555555555555",
                "type": null,
                "max_volume": null,
                "aliquots": [
                    {
                        "sample": {
                            "actions": {
                                "read": "http://example.org/11111111-2222-3333-0000-000000000000",
                                "create": "http://example.org/11111111-2222-3333-0000-000000000000",
                                "update": "http://example.org/11111111-2222-3333-0000-000000000000",
                                "delete": "http://example.org/11111111-2222-3333-0000-000000000000"
                            },
                            "uuid": "11111111-2222-3333-0000-000000000000",
                            "name": "sample 1"
                        },
                        "quantity": 5,
                        "type": "NA",
                        "unit": "mole",
                        "out_of_bounds": {
                        }
                    },
                    {
                        "quantity": 10,
                        "type": "solvent",
                        "unit": "ul",
                        "out_of_bounds": {
                        }
                    }
                ]
            },
            "G10": {
                "actions": {
                    "read": "http://example.org/11111111-2222-4444-5555-333333333333",
                    "create": "http://example.org/11111111-2222-4444-5555-333333333333",
                    "update": "http://example.org/11111111-2222-4444-5555-333333333333",
                    "delete": "http://example.org/11111111-2222-4444-5555-333333333333"
                },
                "uuid": "11111111-2222-4444-5555-333333333333",
                "type": null,
                "max_volume": null,
                "aliquots": [
                    {
                        "quantity": 20,
                        "type": "solvent",
                        "unit": "ul",
                        "out_of_bounds": {
                        }
                    }
                ]
            }
        }
    }
}
    EOD

  end
end
