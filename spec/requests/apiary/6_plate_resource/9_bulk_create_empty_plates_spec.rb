require "requests/apiary/6_plate_resource/spec_helper"
describe "bulk_create_empty_plates", :plate => true do
  include_context "use core context service"
  it "bulk_create_empty_plates" do
  # **Bulk create new empty plates.**
  # 
  # * `number_of_rows` number of rows in the plate
  # * `number_of_columns` number of columns in the plate
  # * `type` actual type of the plate
  # * `wells_description` map aliquots to well locations

    header('Content-Type', 'application/json; bulk=true')
    header('Accept', 'application/json; representation=minimal')

    response = post "/plates", <<-EOD
    {
    "plates": [
        {
            "number_of_rows": 8,
            "number_of_columns": 12,
            "type": "plate type1",
            "wells_description": {
            }
        },
        {
            "number_of_rows": 8,
            "number_of_columns": 12,
            "type": "plate type2",
            "wells_description": {
            }
        },
        {
            "number_of_rows": 8,
            "number_of_columns": 12,
            "type": "plate type3",
            "wells_description": {
            }
        }
    ]
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "actions": {
    },
    "plates": [
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-555555555555",
                "update": "http://example.org/11111111-2222-3333-4444-555555555555",
                "delete": "http://example.org/11111111-2222-3333-4444-555555555555",
                "create": "http://example.org/11111111-2222-3333-4444-555555555555"
            },
            "uuid": "11111111-2222-3333-4444-555555555555"
        },
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-666666666666",
                "update": "http://example.org/11111111-2222-3333-4444-666666666666",
                "delete": "http://example.org/11111111-2222-3333-4444-666666666666",
                "create": "http://example.org/11111111-2222-3333-4444-666666666666"
            },
            "uuid": "11111111-2222-3333-4444-666666666666"
        },
        {
            "actions": {
                "read": "http://example.org/11111111-2222-3333-4444-777777777777",
                "update": "http://example.org/11111111-2222-3333-4444-777777777777",
                "delete": "http://example.org/11111111-2222-3333-4444-777777777777",
                "create": "http://example.org/11111111-2222-3333-4444-777777777777"
            },
            "uuid": "11111111-2222-3333-4444-777777777777"
        }
    ],
    "size": 3
}
    EOD

  end
end
