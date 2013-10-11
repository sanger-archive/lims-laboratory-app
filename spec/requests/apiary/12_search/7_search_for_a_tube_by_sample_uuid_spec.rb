require "requests/apiary/12_search/spec_helper"
describe "search_for_a_tube_by_sample_uuid", :search => true do
  include_context "use core context service"
  it "search_for_a_tube_by_sample_uuid" do


    sample = Lims::LaboratoryApp::Laboratory::Sample.new
    tube = Lims::LaboratoryApp::Laboratory::Tube.new
    tube << Lims::LaboratoryApp::Laboratory::Aliquot.new({:sample => sample}) 
    tube2 = Lims::LaboratoryApp::Laboratory::Tube.new
    tube2 << Lims::LaboratoryApp::Laboratory::Aliquot.new({:sample => sample}) 
    
    save_with_uuid tube => [1,2,3,4,6], sample => [1,2,3,4,7], tube2 => [1,2,3,4,8]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/searches", <<-EOD
    {
    "search": {
        "description": "search for a tube by its sample uuid",
        "model": "tube",
        "criteria": {
            "sample": {
                "uuid": "11111111-2222-3333-4444-777777777777"
            }
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "search": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "first": "http://example.org/11111111-2222-3333-4444-555555555555/page=1",
            "last": "http://example.org/11111111-2222-3333-4444-555555555555/page=-1"
        },
        "uuid": "11111111-2222-3333-4444-555555555555"
    }
}
    EOD

  # Get the search result

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "/11111111-2222-3333-4444-555555555555/page=1"
    response.should match_json_response(200, <<-EOD) 
    {
    "actions": {
        "read": "http://example.org/11111111-2222-3333-4444-555555555555/page=1",
        "first": "http://example.org/11111111-2222-3333-4444-555555555555/page=1",
        "last": "http://example.org/11111111-2222-3333-4444-555555555555/page=-1"
    },
    "size": 2,
    "tubes": [
        {
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
                            "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
                        },
                        "uuid": "11111111-2222-3333-4444-777777777777",
                        "name": null
                    },
                    "unit": "mole"
                }
            ]
        },
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-888888888888",
                "create": "http://example.org/11111111-2222-3333-4444-888888888888",
                "update": "http://example.org/11111111-2222-3333-4444-888888888888",
                "delete": "http://example.org/11111111-2222-3333-4444-888888888888"
            },
            "uuid": "11111111-2222-3333-4444-888888888888",
            "type": null,
            "max_volume": null,
            "aliquots": [
                {
                    "sample": {
                        "actions": {
                            "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                            "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
                        },
                        "uuid": "11111111-2222-3333-4444-777777777777",
                        "name": null
                    },
                    "unit": "mole"
                }
            ]
        }
    ]
}
    EOD

  end
end
