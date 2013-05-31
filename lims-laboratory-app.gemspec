# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lims-laboratory-app/version'

Gem::Specification.new do |gem|
  gem.name          = "lims-laboratory-app"
  gem.version       = Lims::LaboratoryApp::VERSION
  gem.authors       = ["Maxime Bourget"]
  gem.email         = ["mb14@sanger.ac.uk"]
  gem.description   = %q{Laboratory app}
  gem.summary       = %q{LIMS server providing the main Laboratory functionality : Labware + Order }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  #development
  gem.add_development_dependency('rspec', '~>2.13')
  gem.add_development_dependency('rack-test', '~> 0.6.1')
  gem.add_development_dependency('hashdiff')
end
