# frozen_string_literal: true

require 'csv'
require 'jipcode/address_locator/helper'

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

      File.open(INDEX_VERSION_FILE, 'w') do |f|
        f.write(Jipcode::VERSION)
      end
    rescue StandardError => e
      raise e, 'Failed to create index'
    end

    # @private
    def self.refresh_index_dir
      FileUtils.rm_rf(INDEX_PATH) if File.exist?(INDEX_PATH)
      Dir.mkdir(INDEX_PATH)
    end

    # @private
    def self.collect_index
      # 都道府県コードは1から始まるので一つ余計に作る
      index = Array.new(PREFECTURE_CODE.size + 1) { [] }

      Dir.glob("#{ZIPCODE_PATH}/*.csv").each do |file_name|
        CSV.read(file_name).each do |row|
          _zipcode, prefecture_name, _city, _town = row
          prefecture_code = extract_prefecture_code(prefecture_name)
          index[prefecture_code] << row
        end
      end
      index.shift
      index
    end

    # @private
    def self.export_index(index)
      index.each.with_index(1) do |rows, prefecture_code|
        rows.sort_by! { |row| [row[0], row[2], row[3]] }
        CSV.open("#{INDEX_PATH}/#{prefecture_code}.csv", 'wb') do |csv|
          rows.each { |row| csv << row }
        end
      end
    end

    private_class_method :refresh_index_dir, :collect_index, :export_index
  end
end
