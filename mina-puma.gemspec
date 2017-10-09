# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina/puma/version'

Gem::Specification.new do |spec|
  spec.name          = 'mina-puma'
  spec.version       = Mina::Puma::VERSION
  spec.authors       = ['Tobias Sandelius']
  spec.email         = ['tobias@sandeli.us']
  spec.description   = %q{Puma tasks for Mina}
  spec.summary       = %q{Puma tasks for Mina}
  spec.homepage      = 'https://github.com/sandelius/mina-puma'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mina', '~> 1.2.0'
  spec.add_dependency 'puma', '>= 2.13'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
