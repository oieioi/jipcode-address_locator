# frozen_string_literal: true

require 'csv'
require 'jaro_winkler'
require 'jipcode/address_locator/helper'
require 'jipcode/address_locator/normalizer'

module Jipcode
  module AddressLocator
    # Locate zipcode data by address
    # @param [String] search_address
    # @return [Array<Hash>] zipcode data
    def self.locate(search_address)
      normalized = normalize_address(search_address)

      find_by_address(normalized)
        .map { |address| calc_and_add_distance!(address, normalized) }
        .sort_by { |address| address['distance'] }
        .reverse
    end

    # @private
    def self.find_by_address(search_address)
      prefecture_code = extract_prefecture_code(search_address)
      path = "#{INDEX_PATH}/#{prefecture_code}.csv"
      return [] if prefecture_code.nil?

      CSV.read(path, headers: true).select do |row|
        address = row['normalized_address']
        # 長いほうが短い方に含まれてるか判別
        long = [address, search_address].max
        short = [address, search_address].min
        long.start_with?(short)
      end
    end

    # @private
    def self.calc_and_add_distance!(address, search_address)
      distance = JaroWinkler.distance(address['normalized_address'], search_address)
      address['distance'] = distance
      address
    end

    private_class_method :calc_and_add_distance!, :find_by_address
  end
end
