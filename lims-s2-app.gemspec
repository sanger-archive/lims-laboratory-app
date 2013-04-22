# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lims-s2-app/version'

Gem::Specification.new do |gem|
  gem.name          = "lims-s2-app"
  gem.version       = Lims::S2::App::VERSION
  gem.authors       = ["Maxime Bourget"]
  gem.email         = ["mb14@sanger.ac.uk"]
  gem.description   = %q{S2 app}
  gem.summary       = %q{LIMS server providing the main S2 functionality : Labware + Order }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec', '~>2.8.0')
end
