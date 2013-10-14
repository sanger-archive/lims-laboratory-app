require 'lims-core/helpers'
require 'integrations/spec_helper'

if Lims::Core::Helpers::gem_available("ruby-prof")
  #require 'ruby-prof'
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
      graph = JRuby::Profiler::GraphProfilePrinter.new(data)
      graph.printProfile(stdout)
      result
    end
  end

elsef if Lims::Core::Helpers::gem_available("jruby/profiler")
  require 'jruby/profiler'

  def benchmark_with_graph(profile="profile")
    if ENV["PROFILING"].andtap { |s| s.downcase == 'no' }
      yield
    else
      result = nil
      data = JRuby::Profiler.profile do
        result = yield
      end
      graph = JRuby::Profiler::GraphProfilePrinter.new(data)
      graph.printProfile(stdout)
      result
    end
  end
end
