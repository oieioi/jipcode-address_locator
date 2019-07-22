# frozen_string_literal: true

require 'jipcode/address_locator'

module Jipcode
  # Find zipcode data by address.
  # @note If there are no index files, this method creates them from jipcode.gem data.
  # @param [String] search_address
  # @param [Hash] opt the options to create results.
  # @option opt [String] :distance return with jaro winkler distance
  # @return [Array<Hash>] zipcode data
  def self.locate_by_address(search_address, opt = {})
    AddressLocator.create_index! unless AddressLocator.exist_latest_index?

    AddressLocator.locate(search_address).map do |address_param|
      address = extended_address_from(address_param, opt)
      address[:distance] = address_param['distance'] if opt[:distance]
      address
    end
  end
end
