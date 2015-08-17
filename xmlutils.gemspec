# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xmlutils/version'

Gem::Specification.new do |spec|
  spec.name          = "xmlutils"
  spec.version       = XmlUtils::VERSION
  spec.authors       = ["Jeff McAffee"]
  spec.email         = ["jeff@ktechsystems.com"]
  spec.description   = %q{XML Utility classes library and XmlToGdl application.}
  spec.summary       = %q{XML Utility classes library}
  spec.homepage      = "https://github.com/jmcaffee/xmlutils"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "ktcommon", "~> 0.0.7"
end
