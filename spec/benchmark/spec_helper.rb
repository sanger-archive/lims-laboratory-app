require 'integrations/spec_helper'
require 'ruby-prof'

def benchmark_with_graph(profile="profile")
  if ENV["PROFILING"].andtap { |s| s.downcase == 'no' }
    yield
  else
    RubyProf.start
    yield.tap do
      result = RubyProf.stop
      graph = RubyProf::MultiPrinter.new(result)
      graph.print(:profile => profile, :path => "benchmark")
    end
  end
end
