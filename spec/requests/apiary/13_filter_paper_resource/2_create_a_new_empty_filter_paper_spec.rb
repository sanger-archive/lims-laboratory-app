require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "create_a_new_empty_filter_paper", :filter_paper => true do
  include_context "use core context service"
  it "create_a_new_empty_filter_paper" do
  # **Create a new empty filter paper.**

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/filter_papers", <<-EOD
    {
    "filter_paper": {
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "filter_paper": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "aliquots": [

        ]
    }
}
    EOD

  end
end
