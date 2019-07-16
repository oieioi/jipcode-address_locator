# frozen_string_literal: true

require 'csv'
require 'jaro_winkler'
require 'jipcode/address_locator/helper'

module Jipcode
  module AddressLocator
    # Locate zipcode data by address
    # @param [String] search_address
    # @return [Array<Hash>] zipcode data
    def self.locate(search_address)
      find_by_address(search_address)
        .yield_self { |addresses| calc_and_add_distance(addresses, search_address) }
        .sort_by(&:last)
        .reverse
    end

    # @private
    def self.find_by_address(search_address)
      prefecture_code = extract_prefecture_code(search_address)
      path = "#{INDEX_PATH}/#{prefecture_code}.csv"
      return [] if prefecture_code.nil?

      CSV.read(path).select do |row|
        address = row[1..3].join('')
        # 長いほうが短い方に含まれてるか判別
        long = [address, search_address].max
        short = [address, search_address].min
        long.start_with?(short)
      end
    end

    # @private
    def self.calc_and_add_distance(addresses, search_address)
      addresses.map do |row|
        combined = row[1..3].join('')
        distance = JaroWinkler.distance(combined, search_address)
        row << distance
      end
    end

    private_class_method :calc_and_add_distance, :find_by_address
  end
end
