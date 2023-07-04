# frozen_string_literal: true

RSpec.describe Jipcode::AddressLocator do
  describe '#normalize_address' do
    subject { described_class.normalize_address(address_string) }

    [
      ['東京都千代田区千代田１–１', '東京都千代田区千代田1-1'],
      ['東京都千代田区千代田１丁目２番地３号', '東京都千代田区千代田1-2-3'],
      ['東京都千代田区千代田１丁目２番地３', '東京都千代田区千代田1-2-3'],
      ['東京都千代田区千代田一丁目２の３', '東京都千代田区千代田1-2-3']
    ].each do |test_case|
      address_string, expected = test_case

      context "#{address_string} -> #{expected}" do
        let(:address_string) { address_string }

        it { is_expected.to eq expected }
      end
    end
  end
end
