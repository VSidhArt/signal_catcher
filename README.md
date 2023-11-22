[![Build](https://github.com/VSidhArt/signal_catcher/workflows/Build/badge.svg)](https://github.com/VSidhArt/signal_catcher/actions)

# SignalCatcher

## Overview

SignalCatcher is a Ruby library for financial market analysis, offering a range of technical indicators implemented for ease of use and flexibility. It is designed to assist in the development of trading algorithms and analysis tools, providing reliable and tested methods for market trend and pattern recognition.

## Features

- A variety of technical indicators such as EMA, MACD, RSI, Stochastic, and more.
- Configurable settings for each indicator.
- Integration with TaLib for computational efficiency.
- Easy-to-use interface for both simple and complex analysis.


## Sample raw kline data in exchanges format open_time and OHLCV format
```
raw_klines = [[open_time, open, high, low, close, volume]]
```

## Sample raw strategies in your predefined format
```
raw_strategies = [{strategy_hash: ..., indicator_type: ..., signal_params: {}, indicator_params: {}}]
```

## Run calculations
```
SignalCatcher::Processor.new(raw_klines, raw_strategies).call
```

```
Output example:
#<SignalCatcher::Entities::Kline:0x00007fba5e3c1ed0
  @indicator_storage=
   {"sma_ohlcv_value_close_time_period_20"=>42738.95000000003,
    "sma_ohlcv_value_close_time_period_200"=>nil,
    "rsi_ohlcv_value_close_time_period_20"=>27.388352358863543},
  @ohlcv=[0.4068092e5, 0.411e5, 0.3544045e5, 0.3644531e5, 0.88860891999e5],
  @open_time=1642723200000,
  @signal_storage=
   {"a4e7c29862e457dde5c5a5e569b552eb"=>true, "8b8d931abfee0442bffb1a4645fa92ba"=>false}>,
 #<SignalCatcher::Entities::Kline:0x00007fba5e3c1c00
  @indicator_storage=
   {"sma_ohlcv_value_close_time_period_20"=>42128.212000000036,
    "sma_ohlcv_value_close_time_period_200"=>nil,
    "rsi_ohlcv_value_close_time_period_20"=>25.606893150126425},
  @ohlcv=[0.3644531e5, 0.3683522e5, 0.34008e5, 0.3507142e5, 0.90471338961e5],
  @open_time=1642809600000,
  @signal_storage=
   {"a4e7c29862e457dde5c5a5e569b552eb"=>true, "8b8d931abfee0442bffb1a4645fa92ba"=>false}#>,
...
```

## Troubleshooting

1. In case of problems with `bundle install` like
```bash
current directory: /Users/helper2424/.rbenv/versions/3.1.2/lib/ruby/gems/3.1.0/gems/talib_ruby-1.0.6/ext/talib
make DESTDIR\=
compiling talib.c
talib.c:2:10: fatal error: 'ta-lib/ta_abstract.h' file not found
#include <ta-lib/ta_abstract.h>
	 ^~~~~~~~~~~~~~~~~~~~~~
1 error generated.
make: *** [talib.o] Error 1

make failed, exit code 2
```

Install talib locally
```bash
brew install ta-lib
```

Add library path to bundle config
```bash
bundle config set --global build.talib_ruby --with-talib-include=/opt/homebrew/Cellar/ta-lib/0.4.0/include
```

2. In case of the error:
```ruby
3.1.0/gems/talib_ruby-1.0.6/lib/talib.bundle, 0x0009): symbol not found in flat namespace '_TA_CallFunc' - /Users/helper2424/.rbenv/versions/3.1.2/lib/ruby/gems/3.1.0/gems/talib_ruby-1.0.6/lib/talib.bundle
```

Try to reinstall `ta-lib` the following way:
```bash
sudo env ARCHFLAGS="-arch arm64" gem install talib_ruby -- --with-talib-include="$(brew --prefix ta-lib)/include"  --with-talib-lib="$(brew --prefix ta-lib)/lib"
```

This fix is for MACOS with a silicon chip. In case of using another architecture change `-arch arm64` to `-arch x86_64'.
