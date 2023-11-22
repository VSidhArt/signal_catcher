# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # Rsi class for calculating the Relative Strength Index.
    class Rsi < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInRealMixin
      register_setting :time_period, default: 14, type: Integer, min: 1, max: 200
      register_setting :ohlcv_value, default: :close, type: Symbol, enum: FULL_OHLVC_LIST

      private

      def talib_function_name
        'RSI'
      end

      # Configures the parameters for the RSI indicator.
      # @param c_function [TaLib::Function] The TaLib function to configure parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_int(0, time_period)
      end

      # The multiplier used for the RSI output values.
      # @return [Integer] The multiplier value.
      def multiplier
        100_000
      end
    end
  end
end
