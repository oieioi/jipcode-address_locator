# frozen_string_literal: true

require 'csv'
require 'fileutils'
require 'jipcode/address_locator/helper'
require 'jipcode/address_locator/normalizer'

module Jipcode
  module AddressLocator
    # Make sure Jipcode version and index version are the same.
    # @return [Boolean] result
    def self.exist_latest_index?
      return false unless File.exist?(INDEX_VERSION_FILE)

      version = File.read(INDEX_VERSION_FILE)
      version == Jipcode::VERSION
    end

    # Create index files by Jipcode data.
    def self.create_index!
      refresh_index_dir

      index = collect_index

      export_index(index)

      File.write(INDEX_VERSION_FILE, Jipcode::VERSION)
    end

    # @private
    def self.refresh_index_dir
      FileUtils.rm_rf(INDEX_PATH)
      Dir.mkdir(INDEX_PATH)
    end

    # @private
    def self.collect_index
      index = 47.times.each_with_object({}) { |item, memo| memo[item + 1] = [] }

      Dir.glob("#{ZIPCODE_PATH}/*.csv").each do |file_name|
        CSV.read(file_name).each do |row|
          _zipcode, prefecture_name, city, town = row
          row << normalize_address("#{prefecture_name}#{city}#{town}")
          prefecture_code = extract_prefecture_code(prefecture_name)
          index[prefecture_code] << row
        end
      end

      index
    end

    # @private
    def self.export_index(index)
      index.each do |prefecture_code, rows|
        rows.sort_by! { |row| [row[0], row[2], row[3]] }
        CSV.open("#{INDEX_PATH}/#{prefecture_code}.csv", 'wb') do |csv|
          csv << %w[
            zipcode
            prefecture_name
            city
            town
            prefecture_kana
            city_kana
            town_kana
            normalized_address
          ]
          rows.each { |row| csv << row }
        end
      end
    end

    private_class_method :refresh_index_dir, :collect_index, :export_index
  end
end
