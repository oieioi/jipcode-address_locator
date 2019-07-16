[![Build Status](https://travis-ci.com/oieioi/jipcode-address_locator.svg?branch=master)](https://travis-ci.com/oieioi/jipcode-address_locator)

# Jipcode::AddressLocator

[Jipcode](http://rubygems.org/gems/jipcode)に住所から郵便番号データを検索するメソッド(`locate_by_address`)を追加します。

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

[Jaro-Winkler](https://rubygems.org/gems/jaro_winkler)距離計算の結果から近い順に郵便番号情報を返します。

[Jipcode](http://rubygems.org/gems/jipcode)の最新郵便番号のインデックスをまだ持っていない場合インデックスファイルを作成します。なので初回の処理は重いです

```ruby
require 'jipcode'
require 'jipcode/address_locator'

Jipcode.locate_by_address '東京都千代田区千代田1-1', prefecture_code: true, distance: true
# [
#   {:zipcode=>"1000001", :prefecture=>"東京都", :city=>"千代田区", :town=>"千代田", :prefecture_code=>13, :distance=>0.9538461538461538},
#   {:zipcode=>"1000000", :prefecture=>"東京都", :city=>"千代田区", :town=>nil, :prefecture_code=>13, :distance=>0.9076923076923077}
# ]
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
