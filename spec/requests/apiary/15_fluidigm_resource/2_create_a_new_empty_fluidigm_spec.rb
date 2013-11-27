require "requests/apiary/15_fluidigm_resource/spec_helper"
describe "create_a_new_empty_fluidigm", :fluidigm => true do
  include_context "use core context service"
  it "create_a_new_empty_fluidigm" do
  # **Create a fluidigm resource.**
  # 
  # * `number_of_rows` number of rows on the fluidigm labware
  # * `number_of_columns` number of columns on the fluidigm labware
  # * `fluidigm_wells_description` map aliquots to wells

    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = post "/fluidigms", <<-EOD
    {
    "fluidigm": {
        "number_of_rows": 16,
        "number_of_columns": 12,
        "fluidigm_wells_description": {
        }
    }
}
    EOD
    response.should match_json_response(200, <<-EOD) 
    {
    "fluidigm": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-4444-555555555555",
            "create": "http://example.org/11111111-2222-3333-4444-555555555555",
            "update": "http://example.org/11111111-2222-3333-4444-555555555555",
            "delete": "http://example.org/11111111-2222-3333-4444-555555555555"
        },
        "uuid": "11111111-2222-3333-4444-555555555555",
        "number_of_rows": 16,
        "number_of_columns": 12,
        "fluidigm_wells": {
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
            "S1": [

            ],
            "S2": [

            ],
            "S3": [

            ],
            "S4": [

            ],
            "S5": [

            ],
            "S6": [

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
            "S7": [

            ],
            "S8": [

            ],
            "S9": [

            ],
            "S10": [

            ],
            "S11": [

            ],
            "S12": [

            ],
            "A13": [

            ],
            "A14": [

            ],
            "A15": [

            ],
            "A16": [

            ],
            "A17": [

            ],
            "A18": [

            ],
            "S13": [

            ],
            "S14": [

            ],
            "S15": [

            ],
            "S16": [

            ],
            "S17": [

            ],
            "S18": [

            ],
            "A19": [

            ],
            "A20": [

            ],
            "A21": [

            ],
            "A22": [

            ],
            "A23": [

            ],
            "A24": [

            ],
            "S19": [

            ],
            "S20": [

            ],
            "S21": [

            ],
            "S22": [

            ],
            "S23": [

            ],
            "S24": [

            ],
            "A25": [

            ],
            "A26": [

            ],
            "A27": [

            ],
            "A28": [

            ],
            "A29": [

            ],
            "A30": [

            ],
            "S25": [

            ],
            "S26": [

            ],
            "S27": [

            ],
            "S28": [

            ],
            "S29": [

            ],
            "S30": [

            ],
            "A31": [

            ],
            "A32": [

            ],
            "A33": [

            ],
            "A34": [

            ],
            "A35": [

            ],
            "A36": [

            ],
            "S31": [

            ],
            "S32": [

            ],
            "S33": [

            ],
            "S34": [

            ],
            "S35": [

            ],
            "S36": [

            ],
            "A37": [

            ],
            "A38": [

            ],
            "A39": [

            ],
            "A40": [

            ],
            "A41": [

            ],
            "A42": [

            ],
            "S37": [

            ],
            "S38": [

            ],
            "S39": [

            ],
            "S40": [

            ],
            "S41": [

            ],
            "S42": [

            ],
            "A43": [

            ],
            "A44": [

            ],
            "A45": [

            ],
            "A46": [

            ],
            "A47": [

            ],
            "A48": [

            ],
            "S43": [

            ],
            "S44": [

            ],
            "S45": [

            ],
            "S46": [

            ],
            "S47": [

            ],
            "S48": [

            ],
            "A49": [

            ],
            "A50": [

            ],
            "A51": [

            ],
            "A52": [

            ],
            "A53": [

            ],
            "A54": [

            ],
            "S49": [

            ],
            "S50": [

            ],
            "S51": [

            ],
            "S52": [

            ],
            "S53": [

            ],
            "S54": [

            ],
            "A55": [

            ],
            "A56": [

            ],
            "A57": [

            ],
            "A58": [

            ],
            "A59": [

            ],
            "A60": [

            ],
            "S55": [

            ],
            "S56": [

            ],
            "S57": [

            ],
            "S58": [

            ],
            "S59": [

            ],
            "S60": [

            ],
            "A61": [

            ],
            "A62": [

            ],
            "A63": [

            ],
            "A64": [

            ],
            "A65": [

            ],
            "A66": [

            ],
            "S61": [

            ],
            "S62": [

            ],
            "S63": [

            ],
            "S64": [

            ],
            "S65": [

            ],
            "S66": [

            ],
            "A67": [

            ],
            "A68": [

            ],
            "A69": [

            ],
            "A70": [

            ],
            "A71": [

            ],
            "A72": [

            ],
            "S67": [

            ],
            "S68": [

            ],
            "S69": [

            ],
            "S70": [

            ],
            "S71": [

            ],
            "S72": [

            ],
            "A73": [

            ],
            "A74": [

            ],
            "A75": [

            ],
            "A76": [

            ],
            "A77": [

            ],
            "A78": [

            ],
            "S73": [

            ],
            "S74": [

            ],
            "S75": [

            ],
            "S76": [

            ],
            "S77": [

            ],
            "S78": [

            ],
            "A79": [

            ],
            "A80": [

            ],
            "A81": [

            ],
            "A82": [

            ],
            "A83": [

            ],
            "A84": [

            ],
            "S79": [

            ],
            "S80": [

            ],
            "S81": [

            ],
            "S82": [

            ],
            "S83": [

            ],
            "S84": [

            ],
            "A85": [

            ],
            "A86": [

            ],
            "A87": [

            ],
            "A88": [

            ],
            "A89": [

            ],
            "A90": [

            ],
            "S85": [

            ],
            "S86": [

            ],
            "S87": [

            ],
            "S88": [

            ],
            "S89": [

            ],
            "S90": [

            ],
            "A91": [

            ],
            "A92": [

            ],
            "A93": [

            ],
            "A94": [

            ],
            "A95": [

            ],
            "A96": [

            ],
            "S91": [

            ],
            "S92": [

            ],
            "S93": [

            ],
            "S94": [

            ],
            "S95": [

            ],
            "S96": [

            ]
        }
    }
}
    EOD

  end
end
