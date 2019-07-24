[![Gem Version](https://badge.fury.io/rb/jipcode-address_locator.svg)](https://badge.fury.io/rb/jipcode-address_locator)
[![Build Status](https://travis-ci.com/oieioi/jipcode-address_locator.svg?branch=master)](https://travis-ci.com/oieioi/jipcode-address_locator)

# Jipcode::AddressLocator

[jipcode](http://rubygems.org/gems/jipcode)に住所から郵便番号データを検索するメソッド(`locate_by_address`)を追加します。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jipcode-address_locator'
```
And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install jipcode-address_locator
```

## 使用方法

### 住所から郵便番号情報を検索する

[jaro-winkler](https://rubygems.org/gems/jaro_winkler)距離計算の結果から近い順に郵便番号情報を返す。

```ruby
require 'jipcode'
require 'jipcode/address_locator'

Jipcode.locate_by_address '東京都千代田区千代田1-1', prefecture_code: true, distance: true
# [
#   {:zipcode=>"1008111", :prefecture=>"東京都", :city=>"千代田区", :town=>"千代田１−１", :prefecture_code=>13, :distance=>1.0},
#   {:zipcode=>"1000001", :prefecture=>"東京都", :city=>"千代田区", :town=>"千代田", :prefecture_code=>13, :distance=>0.9538461538461538},
#   {:zipcode=>"1000000", :prefecture=>"東京都", :city=>"千代田区", :town=>nil, :prefecture_code=>13, :distance=>0.9076923076923077}
# ]
```

#### 備考

[jipcode](http://rubygems.org/gems/jipcode)の該当するバージョンのインデックスをまだ持っていない場合インデックスファイルを作成する。

受け取った住所は以下の正規化を行う。(`Jipcode::AddressLocator.normalize_address()`)

- 全角の数字とハイフンを半角にする
- 「漢数字 + `丁目`」 を「半角数字 + ハイフン」 にする
- `丁目`、`番地`、`号`などをハイフンにする

例
```ruby
Jipcode::AddressLocator.normalize_address('稲穂県ミドリ市一番町一丁目２の3番')
# => '稲穂県ミドリ市一番町1-2-3'
```

### インデックスを更新する

明示的にインデックスを作り直す場合は以下を実行する。

```ruby
Jipcode::AddressLocator.create_index!
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
