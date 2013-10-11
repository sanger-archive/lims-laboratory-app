require "requests/apiary/5_spin_column_resource/spec_helper"
describe "create_a_new_empty_spin_column", :spin_column => true do
  include_context "use core context service"
  it "create_a_new_empty_spin_column" do
  # **Create a new empty spin column.**

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/spin_columns", <<-EOD
    {
    "spin_column": {
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "spin_column": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "aliquots": [

        ]
    }
}
    EOD

  end
end
