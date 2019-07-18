# frozen_string_literal: true

require 'jipcode/address_locator/locator'
require 'jipcode/address_locator/indexer'
require 'jipcode/address_locator/version'
require 'jipcode/address_locator/ext_jipcode'

module Jipcode
  module AddressLocator
    INDEX_PATH = "#{File.dirname(__FILE__)}/../../zipcode/by_prefecture/latest"
    INDEX_VERSION_FILE = "#{File.dirname(__FILE__)}/../../zipcode/by_prefecture/version"
  end
end
