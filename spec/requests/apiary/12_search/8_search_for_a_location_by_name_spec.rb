require "requests/apiary/12_search/spec_helper"
describe "search_for_a_location_by_name", :search => true do
  include_context "use core context service"
  it "search_for_a_location_by_name" do


  # **Search for a location by name**
  # 
  # * `description` describe the search
  # * `model` location model 
  # * `criteria` set parameters for the search. Here, it can be a combination of the following attributes:
  #     * `name`
  # 
  # To actually get the search results, you need to access the first page of result 
  # thanks to the `first` action in the JSON response.
    location = Lims::LaboratoryApp::Organization::Location.new({
      :name => 'ABC Hospital',
      :address => 'CB11 3DF Cambridge 123 Sample Way',
      :internal => false
    })
    
    save_with_uuid location => [1,2,3,4,7]

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/searches", <<-EOD
    {
    "search": {
        "description": "search for a location by name",
        "model": "location",
        "criteria": {
            "comparison": {
                "name": {
                    "like": "ABC"
                }
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
    "size": 1,
    "locations": [
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                "create": "http://example.org/11111111-2222-3333-4444-777777777777",
                "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                "delete": "http://example.org/11111111-2222-3333-4444-777777777777"
            },
            "uuid": "11111111-2222-3333-4444-777777777777",
            "name": "ABC Hospital",
            "address": "CB11 3DF Cambridge 123 Sample Way",
            "internal": false
        }
    ]
}
    EOD

  end
end
