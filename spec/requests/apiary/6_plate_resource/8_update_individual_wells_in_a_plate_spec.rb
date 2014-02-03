require "requests/apiary/6_plate_resource/spec_helper"
describe "update_individual_wells_in_a_plate", :plate => true do
  include_context "use core context service"
  it "update_individual_wells_in_a_plate" do
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 2')
    plate = Lims::LaboratoryApp::Laboratory::Plate.new(:number_of_rows => 8, :number_of_columns => 12)
    plate["A1"] << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 5, :type => "RNA", :sample => sample1)
    plate["C5"] << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample2)
    save_with_uuid sample1 => [1,2,3,4,6], sample2 => [1,2,3,4,7], plate => [1,2,3,4,5]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = put "/11111111-2222-3333-4444-555555555555", <<-EOD
    {
    "wells": {
        "A1": {
            "sample_uuid": "11111111-2222-3333-4444-666666666666",
            "out_of_bounds": {
                "attribute_1": "value 1",
                "attribute_2": "value 2"
            }
        },
        "C5": {
            "sample_uuid": "11111111-2222-3333-4444-777777777777",
            "aliquot_type": "new type",
            "aliquot_quantity": 100
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "plate": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "number_of_rows": 8,
        "number_of_columns": 12,
        "type": null,
        "location": null,
        "wells": {
            "A1": [
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
                    "quantity": 5,
                    "type": "RNA",
                    "unit": "mole",
                    "out_of_bounds": {
                        "attribute_1": "value 1",
                        "attribute_2": "value 2"
                    }
                }
            ],
            "A2": [

            ],
            "A3": [

            ],
            "A4": [

            ],
            "A5": [

            ],
            "A6": [

            ],
            "A7": [

            ],
            "A8": [

            ],
            "A9": [

            ],
            "A10": [

            ],
            "A11": [

            ],
            "A12": [

            ],
            "B1": [

            ],
            "B2": [

            ],
            "B3": [

            ],
            "B4": [

            ],
            "B5": [

            ],
            "B6": [

            ],
            "B7": [

            ],
            "B8": [

            ],
            "B9": [

            ],
            "B10": [

            ],
            "B11": [

            ],
            "B12": [

            ],
            "C1": [

            ],
            "C2": [

            ],
            "C3": [

            ],
            "C4": [

            ],
            "C5": [
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
                    "quantity": 100,
                    "type": "new type",
                    "unit": "mole"
                }
            ],
            "C6": [

            ],
            "C7": [

            ],
            "C8": [

            ],
            "C9": [

            ],
            "C10": [

            ],
            "C11": [

            ],
            "C12": [

            ],
            "D1": [

            ],
            "D2": [

            ],
            "D3": [

            ],
            "D4": [

            ],
            "D5": [

            ],
            "D6": [

            ],
            "D7": [

            ],
            "D8": [

            ],
            "D9": [

            ],
            "D10": [

            ],
            "D11": [

            ],
            "D12": [

            ],
            "E1": [

            ],
            "E2": [

            ],
            "E3": [

            ],
            "E4": [

            ],
            "E5": [

            ],
            "E6": [

            ],
            "E7": [

            ],
            "E8": [

            ],
            "E9": [

            ],
            "E10": [

            ],
            "E11": [

            ],
            "E12": [

            ],
            "F1": [

            ],
            "F2": [

            ],
            "F3": [

            ],
            "F4": [

            ],
            "F5": [

            ],
            "F6": [

            ],
            "F7": [

            ],
            "F8": [

            ],
            "F9": [

            ],
            "F10": [

            ],
            "F11": [

            ],
            "F12": [

            ],
            "G1": [

            ],
            "G2": [

            ],
            "G3": [

            ],
            "G4": [

            ],
            "G5": [

            ],
            "G6": [

            ],
            "G7": [

            ],
            "G8": [

            ],
            "G9": [

            ],
            "G10": [

            ],
            "G11": [

            ],
            "G12": [

            ],
            "H1": [

            ],
            "H2": [

            ],
            "H3": [

            ],
            "H4": [

            ],
            "H5": [

            ],
            "H6": [

            ],
            "H7": [

            ],
            "H8": [

            ],
            "H9": [

            ],
            "H10": [

            ],
            "H11": [

            ],
            "H12": [

            ]
        }
    }
}
    EOD

  end
end
