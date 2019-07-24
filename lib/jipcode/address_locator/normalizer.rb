# frozen_string_literal: true

module Jipcode
  module AddressLocator
    # Normalize japanese address for search.
    # @example
    #   Jipcode::AddressLocator.normalize_address('稲穂県ミドリ市一番町一丁目２の3番')
    #   # => '稲穂県ミドリ市一番町1-2-3'
    # @param [String] raw_address
    # @return [String] normalized address
    def self.normalize_address(raw_address)
      zenkaku2hankaku(raw_address)
        .yield_self { |address| kansuji2hankaku(address) }
        .yield_self { |address| jukyohyouji2hyphen(address) }
    end

    # 全角数字ハイフン→半角数字ハイフン
    # @private
    def self.zenkaku2hankaku(string)
      string.tr('０-９', '0-9')
            .tr('–−', '-')
    end

    # 住居表示の漢数字を半角数字に置き換える
    # @private
    def self.kansuji2hankaku(string)
      # 漢数字は「丁目」の前に使われてるもののみを半角にする
      string.gsub(/[一二三四五六七八九十]+丁目/) do |match|
        match.tr('一二三四五六七八九', '1-9')
        # TODO: 十丁目 -> 10、十三丁目 -> 13 二十丁目 -> 20
      end
    end

    # 丁目・番・号・地割・番地をハイフンに置換する
    #       1丁目2番3号 -> 1-2-3
    #       1丁目2番3 -> 1-2-3
    #       1丁目2-3 -> 1-2-3
    #       1丁目2番 -> 1-2
    #       1地割2番地 -> 1-2
    #       1丁目2番地の3 -> 1-2-3
    #       etc..
    # @private
    # @see https://ja.wikipedia.org/wiki/%E4%BD%8F%E5%B1%85%E8%A1%A8%E7%A4%BA
    GAIKU_HYOUJI = %w[
      丁目
      番地
      番
      号
      地割
      の
    ].freeze
    def self.jukyohyouji2hyphen(string)
      string.gsub(/\d(#{GAIKU_HYOUJI.join('|')})/) { |match| match.gsub(/(#{GAIKU_HYOUJI.join('|')})/, '-') }
            .gsub(/-$/, '')
    end

    private_class_method :jukyohyouji2hyphen, :kansuji2hankaku, :zenkaku2hankaku
  end
end
