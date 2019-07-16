# frozen_string_literal: true

module Jipcode
  module AddressLocator
    # @private
    def self.extract_prefecture_code(address)
      prefecture_name = address.match(/\A(#{prefecture_names.join('|')})/).to_s
      PREFECTURE_CODE.invert[prefecture_name]
    end

    # @private
    def self.prefecture_names
      PREFECTURE_CODE.values
    end

    private_class_method :prefecture_names, :extract_prefecture_code
  end
end
