require "requests/apiary/4_tube_rack_resource/spec_helper"
describe "update_a_tube_rack", :tube_rack => true do
  include_context "use core context service"
  it "update_a_tube_rack" do
  # **Update a tube rack.**
  # All aliquots in each tube of the tube rack will be updated with 
  # `aliquot_type` and `aliquot_quantity`.
  # 
  # * `aliquot_type`
  # * `aliquot_quantity` volume (ul) if liquid, mass (mg) if solid
  # * `tubes` new tubes to add to the tube rack. The specified locations need to be empty.
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 2')
    source_tube1 = Lims::LaboratoryApp::Laboratory::Tube.new << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 5, :type => "NA", :sample => sample1)
    source_tube2 = Lims::LaboratoryApp::Laboratory::Tube.new << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 5, :type => "NA", :sample => sample2)
    tube_rack = Lims::LaboratoryApp::Laboratory::TubeRack.new(:number_of_columns => 12, :number_of_rows => 8)
    tube_rack["A1"] = source_tube1
    tube_rack["E5"] = source_tube2
    new_sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'new sample 1')
    new_tube1 = Lims::LaboratoryApp::Laboratory::Tube.new << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 5, :type => "NA", :sample => new_sample1)
    new_sample2 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'new sample 2')
    new_tube2 = Lims::LaboratoryApp::Laboratory::Tube.new << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 5, :type => "NA", :sample => new_sample2)
    
    save_with_uuid({
      sample1 => [1,2,3,0,0], sample2 => [1,2,3,0,1], 
      source_tube1 => [1,2,3,4,5], source_tube2 => [1,2,3,4,6], tube_rack => [1,2,3,4,7],
      new_sample1 => [1,2,4,5,1], new_sample2 => [1,2,4,5,2],
      new_tube1 => [1,2,4,5,3], new_tube2 => [1,2,4,5,4]
    })

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = put "/11111111-2222-3333-4444-777777777777", <<-EOD
    {
    "aliquot_type": "DNA",
    "aliquot_quantity": 10,
    "tubes": {
        "C2": "11111111-2222-4444-5555-333333333333",
        "G10": "11111111-2222-4444-5555-444444444444"
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "tube_rack": {
        "actions": {
            "create": "http://example.org/11111111-2222-3333-4444-777777777777",
            "read": "http://example.org/11111111-2222-3333-4444-777777777777",
            "update": "http://example.org/11111111-2222-3333-4444-777777777777",
            "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
        },
        "uuid": "11111111-2222-3333-4444-777777777777",
        "number_of_rows": 8,
        "number_of_columns": 12,
        "tubes": {
            "A1": {
                "actions": {
                    "create": "http://example.org/11111111-2222-3333-4444-555555555555",
                    "read": "http://example.org/11111111-2222-3333-4444-555555555555",
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
                        "quantity": 10,
                        "type": "DNA",
                        "unit": "mole"
                    }
                ]
            },
            "C2": {
                "actions": {
                    "create": "http://example.org/11111111-2222-4444-5555-333333333333",
                    "read": "http://example.org/11111111-2222-4444-5555-333333333333",
                    "update": "http://example.org/11111111-2222-4444-5555-333333333333",
                    "delete": "http://example.org/11111111-2222-4444-5555-333333333333"
                },
                "uuid": "11111111-2222-4444-5555-333333333333",
                "type": null,
                "max_volume": null,
                "aliquots": [
                    {
                        "sample": {
                            "actions": {
                                "read": "http://example.org/11111111-2222-4444-5555-111111111111",
                                "create": "http://example.org/11111111-2222-4444-5555-111111111111",
                                "update": "http://example.org/11111111-2222-4444-5555-111111111111",
                                "delete": "http://example.org/11111111-2222-4444-5555-111111111111"
                            },
                            "uuid": "11111111-2222-4444-5555-111111111111",
                            "name": "new sample 1"
                        },
                        "quantity": 10,
                        "type": "DNA",
                        "unit": "mole"
                    }
                ]
            },
            "E5": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                },
                "uuid": "11111111-2222-3333-4444-666666666666",
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
                            "name": "sample 2"
                        },
                        "quantity": 10,
                        "type": "DNA",
                        "unit": "mole"
                    }
                ]
            },
            "G10": {
                "actions": {
                    "read": "http://example.org/11111111-2222-4444-5555-444444444444",
                    "create": "http://example.org/11111111-2222-4444-5555-444444444444",
                    "update": "http://example.org/11111111-2222-4444-5555-444444444444",
                    "delete": "http://example.org/11111111-2222-4444-5555-444444444444"
                },
                "uuid": "11111111-2222-4444-5555-444444444444",
                "type": null,
                "max_volume": null,
                "aliquots": [
                    {
                        "sample": {
                            "actions": {
                                "read": "http://example.org/11111111-2222-4444-5555-222222222222",
                                "create": "http://example.org/11111111-2222-4444-5555-222222222222",
                                "update": "http://example.org/11111111-2222-4444-5555-222222222222",
                                "delete": "http://example.org/11111111-2222-4444-5555-222222222222"
                            },
                            "uuid": "11111111-2222-4444-5555-222222222222",
                            "name": "new sample 2"
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
    EOD

  end
end
