# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # Macd class for calculating the Moving Average Convergence Divergence.
    class Macd < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInRealMixin
      register_setting :fast_period, default: 12, type: Integer, min: 2, max: 200
      register_setting :slow_period, default: 26, type: Integer, min: 2, max: 200
      register_setting :signal_period, default: 9, type: Integer, min: 1, max: 200
      register_setting :ohlcv_value, default: :close, type: Symbol, enum: FULL_OHLVC_LIST

      private

      def talib_function_name
        'MACD'
      end

      # Configures the parameters for the MACD indicator.
      # @param c_function [TaLib::Function] The TaLib function to configure parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_int(0, fast_period)
        c_function.opt_int(1, slow_period)
        c_function.opt_int(2, signal_period)
      end

      # The number of output arrays for MACD (out_macd, out_macd_signal, out_macd_hist).
      # @return [Integer] The number of outputs.
      def output_count
        3
      end
    end
  end
end
