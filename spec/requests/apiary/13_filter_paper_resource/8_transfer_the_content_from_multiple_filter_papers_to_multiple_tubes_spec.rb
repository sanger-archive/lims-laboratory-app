require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "transfer_the_content_from_multiple_filter_papers_to_multiple_tubes", :filter_paper => true do
  include_context "use core context service"
  it "transfer_the_content_from_multiple_filter_papers_to_multiple_tubes" do
  # **Transfer the content from the location(s) of multiple filter papers to 1 or multiple tubes**.
  # 
  # This action transfers the content of 1 or more location(s) of multiple Filter Paper
  # to to 1 or more tube(s).
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 2')
    
    filter_paper1 = Lims::LaboratoryApp::Laboratory::FilterPaper.new
    filter_paper1 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 100, :type => "sample", :sample => sample1)
    filter_paper2 = Lims::LaboratoryApp::Laboratory::FilterPaper.new
    filter_paper2 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 100, :type => "sample", :sample => sample2)
    
    tube1 = Lims::LaboratoryApp::Laboratory::Tube.new
    tube2 = Lims::LaboratoryApp::Laboratory::Tube.new
    
    save_with_uuid filter_paper1 => [1,2,3,4,3], filter_paper2 => [1,2,3,4,4], sample1 => [1,2,3,0,0], sample2 => [1,2,3,0,1], tube1 => [1,2,3,4,6], tube2 => [1,2,3,4,7]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/transfer_tubes_to_tubes", <<-EOD
    {
    "transfer_tubes_to_tubes": {
        "transfers": [
            {
                "source_uuid": "11111111-2222-3333-4444-333333333333",
                "target_uuid": "11111111-2222-3333-4444-666666666666",
                "amount": 5,
                "aliquot_type": "DNA"
            },
            {
                "source_uuid": "11111111-2222-3333-4444-444444444444",
                "target_uuid": "11111111-2222-3333-4444-777777777777",
                "amount": 10,
                "aliquot_type": "DNA"
            }
        ]
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "transfer_tubes_to_tubes": {
        "actions": {
        },
        "user": "user@example.com",
        "application": "application_id",
        "result": {
            "sources": [
                {
                    "filter_paper": {
                        "actions": {
                            "read": "http://example.org/11111111-2222-3333-4444-333333333333",
                            "create": "http://example.org/11111111-2222-3333-4444-333333333333",
                            "update": "http://example.org/11111111-2222-3333-4444-333333333333",
                            "delete": "http://example.org/11111111-2222-3333-4444-333333333333"
                        },
                        "uuid": "11111111-2222-3333-4444-333333333333",
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
                                "quantity": 100,
                                "type": "sample",
                                "unit": "mole"
                            }
                        ]
                    }
                },
                {
                    "filter_paper": {
                        "actions": {
                            "read": "http://example.org/11111111-2222-3333-4444-444444444444",
                            "create": "http://example.org/11111111-2222-3333-4444-444444444444",
                            "update": "http://example.org/11111111-2222-3333-4444-444444444444",
                            "delete": "http://example.org/11111111-2222-3333-4444-444444444444"
                        },
                        "uuid": "11111111-2222-3333-4444-444444444444",
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
                                "quantity": 100,
                                "type": "sample",
                                "unit": "mole"
                            }
                        ]
                    }
                }
            ],
            "targets": [
                {
                    "tube": {
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
                                        "read": "http://example.org/11111111-2222-3333-0000-000000000000",
                                        "create": "http://example.org/11111111-2222-3333-0000-000000000000",
                                        "update": "http://example.org/11111111-2222-3333-0000-000000000000",
                                        "delete": "http://example.org/11111111-2222-3333-0000-000000000000"
                                    },
                                    "uuid": "11111111-2222-3333-0000-000000000000",
                                    "name": "sample 1"
                                },
                                "type": "DNA",
                                "unit": "mole"
                            }
                        ]
                    }
                },
                {
                    "tube": {
                        "actions": {
                            "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
                        },
                        "uuid": "11111111-2222-3333-4444-777777777777",
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
                                "type": "DNA",
                                "unit": "mole"
                            }
                        ]
                    }
                }
            ]
        },
        "transfers": [
            {
                "source_uuid": "11111111-2222-3333-4444-333333333333",
                "target_uuid": "11111111-2222-3333-4444-666666666666",
                "amount": 5,
                "aliquot_type": "DNA"
            },
            {
                "source_uuid": "11111111-2222-3333-4444-444444444444",
                "target_uuid": "11111111-2222-3333-4444-777777777777",
                "amount": 10,
                "aliquot_type": "DNA"
            }
        ]
    }
}
    EOD

  end
end
