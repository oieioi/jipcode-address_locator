# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jipcode/address_locator/version'

Gem::Specification.new do |spec|
  spec.name          = 'jipcode-address_locator'
  spec.version       = Jipcode::AddressLocator::VERSION
  spec.authors       = ['oieioi']
  spec.email         = ['atsuinatsu.samuifuyu@gmail.com']

  spec.summary       = 'Extend jipcode.gem to locate zipcode data by address'
  spec.description   = 'Extend jipcode.gem to locate zipcode data by address'
  spec.homepage      = 'https://github.com/oieioi/jipcode-address_locator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'jaro_winkler', '~> 1.5.3'
  spec.add_dependency 'jipcode', '~> 1.5.0'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
