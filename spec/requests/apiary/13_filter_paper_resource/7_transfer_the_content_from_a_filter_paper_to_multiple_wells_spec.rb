require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "transfer_the_content_from_a_filter_paper_to_multiple_wells", :filter_paper => true do
  include_context "use core context service"
  it "transfer_the_content_from_a_filter_paper_to_multiple_wells" do
  # **Transfer the content from the location(s) of a filter paper to 1 or multiple wells**.
  # 
  # This action transfers the content of 1 or more location(s) of a Filter Paper
  # to to 1 or more well(s).
  # 
  # * `source_uuid` uuid of the source Filter Paper
  # * `target_uuid` uuid of the target tube
  # * `transfer_map` map locations in the source filter paper
  # to other locations in the target wells
  # 
  # The example below shows how to make a transfer from a filter paper to multiple wells:
  # 
  # * from tube `11111111-2222-3333-4444-444444444444` to plate `11111111-2222-3333-4444-666666666666`
  # We are transfering the content of "A1" Location to "B2" well and
  # "A2" Location to "C3" well.
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 2')
    
    filter_paper = Lims::LaboratoryApp::Laboratory::FilterPaper.new(
        :number_of_rows =>      2,
        :number_of_columns =>   2)
    filter_paper["A1"] << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 100, :type => "sample", :sample => sample1)
    filter_paper["A2"] << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 100, :type => "sample", :sample => sample2)
    
    plate = Lims::LaboratoryApp::Laboratory::Plate.new(:number_of_columns => 12, :number_of_rows => 8)
    
    save_with_uuid filter_paper => [1,2,3,4,4], sample1 => [1,2,3,0,0], sample2 => [1,2,3,0,0], plate => [1,2,3,4,6]

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/actions/transfer_locations_to_wells", <<-EOD
    {
    "transfer_locations_to_wells": {
        "source_uuid": "11111111-2222-3333-4444-444444444444",
        "target_uuid": "11111111-2222-3333-4444-666666666666",
        "transfer_map": {
            "A1": "B2",
            "A2": "C3"
        }
    }
}
    EOD
    response.status.should == 200
    response.body.should match_json <<-EOD
    {
    "transfer_locations_to_wells": {
        "actions": {
        },
        "user": "user",
        "application": "application",
        "result": {
            "source": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-444444444444",
                    "create": "http://example.org/11111111-2222-3333-4444-444444444444",
                    "update": "http://example.org/11111111-2222-3333-4444-444444444444",
                    "delete": "http://example.org/11111111-2222-3333-4444-444444444444"
                },
                "uuid": "11111111-2222-3333-4444-444444444444",
                "number_of_rows": 2,
                "number_of_columns": 2,
                "locations": {
                    "A1": [
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
                            "quantity": 0,
                            "type": "sample",
                            "unit": "mole"
                        }
                    ],
                    "A2": [
                        {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-0000-000000000000",
                                    "create": "http://example.org/11111111-2222-3333-0000-000000000000",
                                    "update": "http://example.org/11111111-2222-3333-0000-000000000000",
                                    "delete": "http://example.org/11111111-2222-3333-0000-000000000000"
                                },
                                "uuid": "11111111-2222-3333-0000-000000000000",
                                "name": "sample 2"
                            },
                            "quantity": 0,
                            "type": "sample",
                            "unit": "mole"
                        }
                    ],
                    "B1": [

                    ],
                    "B2": [

                    ]
                }
            },
            "target": {
                "actions": {
                    "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "create": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                    "delete": "http://example.org/11111111-2222-3333-4444-666666666666"
                },
                "uuid": "11111111-2222-3333-4444-666666666666",
                "type": null,
                "number_of_rows": 8,
                "number_of_columns": 12,
                "wells": {
                    "A1": [

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
                            "quantity": 100,
                            "type": "sample",
                            "unit": "mole"
                        }
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
                        {
                            "sample": {
                                "actions": {
                                    "read": "http://example.org/11111111-2222-3333-0000-000000000000",
                                    "create": "http://example.org/11111111-2222-3333-0000-000000000000",
                                    "update": "http://example.org/11111111-2222-3333-0000-000000000000",
                                    "delete": "http://example.org/11111111-2222-3333-0000-000000000000"
                                },
                                "uuid": "11111111-2222-3333-0000-000000000000",
                                "name": "sample 2"
                            },
                            "quantity": 100,
                            "type": "sample",
                            "unit": "mole"
                        }
                    ],
                    "C4": [

                    ],
                    "C5": [

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
        },
        "source_uuid": "11111111-2222-3333-4444-444444444444",
        "target_uuid": "11111111-2222-3333-4444-666666666666",
        "transfer_map": {
            "A1": "B2",
            "A2": "C3"
        }
    }
}
    EOD

  end
end
