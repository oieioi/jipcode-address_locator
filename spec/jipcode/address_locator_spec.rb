# frozen_string_literal: true

RSpec.describe Jipcode::AddressLocator do
  it 'has a version number' do
    expect(Jipcode::AddressLocator::VERSION).not_to be_nil
  end

  describe '.locate_by_address' do
    subject { Jipcode.locate_by_address(address, opts) }

    let(:opts) { { distance: true } }

    context '引数の住所に対応する都道府県がない時' do
      let(:address) { 'FOO県BAR市BAZ' }

      it '空配列を返す' do
        expect(subject).to eq []
      end
    end

    context '引数の住所に対応する都道府県があるとき' do
      let(:address) { '東京都千代田区千代田1-1' }

      it '近い順に住所を返す' do
        expect(subject).to eq [
          { city: '千代田区', distance: 1.0, prefecture: '東京都', town: '千代田１−１', zipcode: '1008111' },
          { city: '千代田区', distance: 0.9538461538461538, prefecture: '東京都', town: '千代田', zipcode: '1000001' },
          { city: '千代田区', distance: 0.9076923076923077, prefecture: '東京都', town: nil, zipcode: '1000000' }
        ]
      end
    end

    context 'Jipcodeのオプションが渡されたとき' do
      let(:address) { '東京都千代田区千代田1-1' }
      let(:opts) { { distance: true, prefecture_code: true, kana: true } }

      it 'オプションデータが含まれる' do
        expect(subject).to eq [
          {
            zipcode: '1008111',
            prefecture: '東京都',
            city: '千代田区',
            town: '千代田１−１',
            prefecture_code: 13,
            prefecture_kana: 'トウキョウト',
            city_kana: 'チヨダク',
            town_kana: '',
            distance: 1.0
          },
          {
            zipcode: '1000001',
            prefecture: '東京都',
            city: '千代田区',
            town: '千代田',
            prefecture_code: 13,
            prefecture_kana: 'トウキョウト',
            city_kana: 'チヨダク',
            town_kana: 'チヨダ',
            distance: 0.9538461538461538
          },
          {
            zipcode: '1000000',
            prefecture: '東京都',
            city: '千代田区',
            town: nil,
            prefecture_code: 13,
            prefecture_kana: 'トウキョウト',
            city_kana: 'チヨダク',
            town_kana: '',
            distance: 0.9076923076923077
          }
        ]
      end
    end
  end
end
