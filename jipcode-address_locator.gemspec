# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jipcode/address_locator/version'

Gem::Specification.new do |spec|
  spec.name          = 'jipcode-address_locator'
  spec.version       = Jipcode::AddressLocator::VERSION
  spec.authors       = ['oieioi']
  spec.email         = ['atsuinatsu.samuifuyu@gmail.com']
  spec.required_ruby_version = '>= 2.7.0'

  spec.summary       = 'Extend jipcode.gem to locate zipcode data by address'
  spec.description   = 'Extend jipcode.gem to locate zipcode data by address'
  spec.homepage      = 'https://github.com/oieioi/jipcode-address_locator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'jaro_winkler', '~> 1.5.3'
  spec.add_dependency 'jipcode', '>= 3.0.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
