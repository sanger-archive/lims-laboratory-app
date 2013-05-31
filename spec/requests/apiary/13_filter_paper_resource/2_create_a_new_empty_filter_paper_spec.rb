require "requests/apiary/13_filter_paper_resource/spec_helper"
describe "create_a_new_empty_filter_paper", :filter_paper => true do
  include_context "use core context service"
  it "create_a_new_empty_filter_paper" do
  # **Create a new empty filter paper.**
  # 
  # * `number_of_rows` number of rows of the filter paper
  # * `number_of_columns` number of columns of the filter paper
  # * `locations_description` map aliquots to locations

    header('Accept', 'application/json')
    header('Content-Type', 'application/json')

    response = post "/filter_papers", <<-EOD
    {
    "filter_paper": {
        "number_of_rows": 2,
        "number_of_columns": 2,
        "locations_description": {
        }
    }
}
    EOD
    response.status.should == 200
    response.body.should match_json <<-EOD
    {
    "filter_paper": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "number_of_rows": 2,
        "number_of_columns": 2,
        "locations": {
            "A1": [

            ],
            "A2": [

            ],
            "B1": [

            ],
            "B2": [

            ]
        }
    }
}
    EOD

  end
end
