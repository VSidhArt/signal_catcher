# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # Ema class for calculating the Exponential Moving Average.
    class Ema < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInRealMixin

      register_setting :time_period, default: 20, type: Integer, min: 1, max: 1000
      register_setting :ohlcv_value, default: :close, type: Symbol, enum: FULL_OHLVC_LIST

      private

      def talib_function_name
        'EMA'
      end

      # Configures the parameters for the EMA indicator.
      # @param c_function [TaLib::Function] The TaLib function to configure parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_int(0, time_period)
      end
    end
  end
end
