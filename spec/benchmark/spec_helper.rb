require 'integrations/spec_helper'
require 'ruby-prof'

def benchmark_with_graph(stdout=STDOUT)
  if ENV["PROFILING"].andtap { |s| s.downcase == 'no' }
    yield
  else
    RubyProf.start
    yield.tap do
      result = RubyProf.stop
      graph = RubyProf::GraphHtmlPrinter.new(result)
      graph.print(stdout, {})
    end
  end
end
