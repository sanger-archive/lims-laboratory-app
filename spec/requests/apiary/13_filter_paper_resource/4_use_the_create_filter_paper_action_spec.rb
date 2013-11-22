require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "use_the_create_filter_paper_action", :filter_paper => true do
  include_context "use core context service"
  it "use_the_create_filter_paper_action" do
  # **Use the create filter paper action.**
    save_with_uuid Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1') => [1,2,3,4,6]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/actions/create_filter_paper", <<-EOD
    {
    "create_filter_paper": {
        "aliquots": [
            {
                "sample_uuid": "11111111-2222-3333-4444-666666666666",
                "type": "DNA",
                "quantity": 2
            }
        ]
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
                "aliquots": [
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
                ]
            },
            "uuid": "11111111-2222-3333-4444-555555555555"
        },
        "labels": null,
        "aliquots": [
            {
                "sample_uuid": "11111111-2222-3333-4444-666666666666",
                "type": "DNA",
                "quantity": 2
            }
        ]
    }
}
    EOD

  end
end
