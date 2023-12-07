# frozen_string_literal: true

module SignalCatcher
  module Indicators
    module Shared
      module PrepareIndicatorDataInPriceMixin
        # Module prepare price data in price for use in ta-lib library

        private

        def prepare_input
          indicator.in_price(*prepare_klines_data_in_price)
        end

        # Prepares the kline data for price based indicators.
        def prepare_klines_data_in_price
          [0, *prepare_ohlcv, nil]
        end

        # Prepares the Open-High-Low-Close-Volume (OHLCV) data.
        def prepare_ohlcv
          ohlcv = klines.map(&:ohlcv).transpose.map(&:flatten)
          adjust_ohlcv_for_multiplier(ohlcv)
        end

        # Adjusts OHLCV data based on the multiplier.
        # @param ohlcv [Array] The original OHLCV data.
        def adjust_ohlcv_for_multiplier(ohlcv)
          return ohlcv if multiplier == 1

          ohlcv.map.with_index { |values, i| i == 4 ? values : values.map { |v| v * multiplier } }
        end
      end
    end
  end
end
