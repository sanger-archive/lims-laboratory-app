require "requests/apiary/17_revision/spec_helper"
describe "tube_and_rack", :revision => true do
  include_context "use core context service"
  it "tube_and_rack" do
    ##################################################
    # Session 1 : create tube and rack
    # Impact : +tube1, +sample1, +sample2, +rack1, +rack2
    ##################################################
    
    sample1 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 1')
    sample2 = Lims::LaboratoryApp::Laboratory::Sample.new(:name => 'sample 2')
    
    tube1 = Lims::LaboratoryApp::Laboratory::Tube.new 
    tube1 << Lims::LaboratoryApp::Laboratory::Aliquot.new(:quantity => 10, :type => "DNA", :sample => sample1)
    
    rack1 = Lims::LaboratoryApp::Laboratory::TubeRack.new(:number_of_rows => 8, :number_of_columns => 12)
    rack2 = Lims::LaboratoryApp::Laboratory::TubeRack.new(:number_of_rows => 8, :number_of_columns => 12)
    
    save_with_uuid({
      sample1 => [1,2,3,0,1],
      sample2 => [1,2,3,0,2],
      tube1 => [1,2,3,1,1],
      rack1 => [1,2,3,2,1],
      rack2 => [1,2,3,2,2],
    })
    
    session_id1 = get_last_session_id
    ##################################################
    # Session 2 : put tube in a rack
    # Impact: !tube1, !rack1
    ##################################################
    
    store.with_session do |session|
      tube = session['11111111-2222-3333-1111-111111111111']
      rack = session['11111111-2222-3333-2222-111111111111']
      rack["A1"] = tube
    end
    session_id2 = get_last_session_id
    
    ##################################################
    # Session 3 : swap sample to sample 2
    # Impact : !tube1, !sample1, !sample2, !rack1
    ##################################################
    
    store.with_session do |session|
      tube = session['11111111-2222-3333-1111-111111111111']
      sample2 = session['11111111-2222-3333-0000-222222222222']
      tube[0].sample = sample2
    end
    session_id3 = get_last_session_id
    
    ##################################################
    # Session 4 : move tube in another rack
    # Impact: !tube1, !rack1, !rack2
    ##################################################
    
    store.with_session do |session|
      tube = session['11111111-2222-3333-1111-111111111111']
      rack1 = session['11111111-2222-3333-2222-111111111111']
      rack2 = session['11111111-2222-3333-2222-222222222222']
      rack1.clear
      rack2["A1"] = tube
    end
    session_id4 = get_last_session_id
    
    #  Modify the time of sessions
    
    [session_id1, session_id2, session_id3, session_id4].each_with_index do |id, i|
      store.database[:sessions].filter(:id => id).update(:end_time => "2014-01-0#{i+2}",
                                                      :start_time => "2014-01-0#{i+1}")
    end



    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "11111111-2222-3333-1111-111111111111/sessions/#{session_id1}"
    response.should match_json_response(200, <<-EOD) 
    {
    "tube": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-1111-111111111111/sessions/#{session_id1}"
        },
        "uuid": "11111111-2222-3333-1111-111111111111",
        "action": "insert",
        "session": {
            "actions": {
                "read": "http://example.org/sessions/#{session_id1}"
            },
            "id": #{session_id1},
            "user": null,
            "backend_application_id": null,
            "parameters": "null",
            "success": true,
            "start_time": "2014-01-01 00:00:00 +0000",
            "end_time": "2014-01-02 00:00:00 +0000"
        },
        "location": null,
        "type": null,
        "max_volume": null,
        "aliquots": [
            {
                "sample": {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-0000-111111111111/sessions/#{session_id1}"
                    },
                    "uuid": "11111111-2222-3333-0000-111111111111",
                    "name": "sample 1"
                },
                "quantity": 10,
                "type": "DNA",
                "unit": "mole"
            }
        ]
    }
}
    EOD


    header('Content-Type', 'application/json')
    header('Accept', 'application/json')

    response = get "11111111-2222-3333-1111-111111111111/sessions/#{session_id2}"
    response.should match_json_response(200, <<-EOD) 
    {
    "tube": {
        "actions": {
            "read": "http://example.org/11111111-2222-3333-1111-111111111111/sessions/#{session_id2}"
        },
        "uuid": "11111111-2222-3333-1111-111111111111",
        "action": "insert",
        "session": {
            "actions": {
                "read": "http://example.org/sessions/#{session_id2}"
            },
            "id": #{session_id2},
            "user": null,
            "backend_application_id": null,
            "parameters": "null",
            "success": true,
            "start_time": "2014-01-02 00:00:00 +0000",
            "end_time": "2014-01-03 00:00:00 +0000"
        },
        "location": null,
        "type": null,
        "max_volume": null,
        "aliquots": [
            {
                "sample": {
                    "actions": {
                        "read": "http://example.org/11111111-2222-3333-0000-111111111111/sessions/#{session_id2}"
                    },
                    "uuid": "11111111-2222-3333-0000-111111111111",
                    "name": "sample 1"
                },
                "quantity": 10,
                "type": "DNA",
                "unit": "mole"
            }
        ]
    }
}
    EOD

  end
end
