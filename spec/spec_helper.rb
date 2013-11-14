require 'lims-api'
require 'rack/test'
require 'hashdiff'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Lims::Api::Server
end

def json_version
  3
end

module Helper
    # converts a structure or a json string to a structure.
    # Transforms as well key to string.
    # @param  [String, Hash, Array]
    # @retun [Hash<String,String>]
    def self.parse_json(arg)
      case arg
      when String then JSON.parse(arg)
      when Array, Hash then arg
      end.recurse{|h| h.rekey { |k| k.to_s } }
    end
end

class Hash
   
  def deep_diff(b)
    a = self
    (a.keys | b.keys).inject({}) do |diff, k|
      if a[k] != b[k]
        if a[k].respond_to?(:deep_diff) && b[k].respond_to?(:deep_diff)
          diff[k] = a[k].deep_diff(b[k])
        else
          diff[k] = [a[k], b[k]]
        end
      end
      diff
    end
  end
   
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.filter_run_excluding :benchmark => true, :logger => true
end

RSpec::Matchers.define :io_stream do |content|
  match { |stream| content == stream.read }
end

RSpec::Matchers.define :match_json_response do |status, body|
  match { |to_match| to_match.status == status && Helper::parse_json(to_match.body) == Helper::parse_json(body) }

  failure_message_for_should do |actual|
    hactual = {:status => status, :body =>  Helper::parse_json(actual.body)}
    hcontent = {:status => actual.status, :body => Helper::parse_json(body) }
    diff = hactual ? hactual.deep_diff(hcontent) : hcontent
    "expected: \n#{JSON::pretty_generate(hcontent)}\nto match: \n#{JSON::pretty_generate(hactual)},\ndiff:\n#{JSON::pretty_generate(diff)} "
  end

end


RSpec::Matchers.define :match_json do |content|

  match { |to_match| Helper::parse_json(to_match) == Helper::parse_json(content) }

  failure_message_for_should do |actual|
    hactual = Helper::parse_json(actual)
    hcontent = Helper::parse_json(content)
    diff = hactual ? hactual.deep_diff(hcontent) : hcontent
    "expected: \n#{JSON::pretty_generate(hcontent)}\nto match: \n#{JSON::pretty_generate(hactual)},\ndiff:\n#{JSON::pretty_generate(diff)} "
  end
end

RSpec::Matchers.define :include_json do |content|
  match do |actual|
    # content is what we specified in the spec
    # it is what needs to be checked as included 
    hactual = Helper::parse_json(actual)
    hcontent = Helper::parse_json(content)

    hcontent.inject(true) do |r, (key, value)|
      r && (hactual[key] == value)
    end

  end

  failure_message_for_should do |actual|
    errors = []
    hactual = Helper::parse_json(actual)
    hcontent = Helper::parse_json(content)

    diffs = HashDiff.diff(hcontent, hactual)
    "expected: \n#{hcontent}\nto match: \n#{hactual},\ndiff:\n#{
    diffs.map { |d| d.join(' ') }.join("\n")}"
  end
end

shared_context "clean store" do
  after(:each) do
    %w{items orders batches searches labels labellables tube_aliquots filter_paper_aliquots spin_column_aliquots windows wells lanes locations fluidigm_wells tag_group_associations aliquots tube_rack_slots tube_racks tubes spin_columns gels plates flowcells filter_papers fluidigms samples oligos snp_assays tag_groups studies users uuid_resources primary_keys}.each do |table|
      db[table.to_sym].delete
    end
    db.disconnect
  end
end

def set_uuid(session, object, uuid)
  session << object
  # save $uuid_sequence in case it's modify by the following block of code
  uuid_sequence = $uuid_sequence
  ur = session.new_uuid_resource_for(object)
  ur.send(:uuid=, uuid).tap do
    $uuid_sequence = uuid_sequence
  end
end
