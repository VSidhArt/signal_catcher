# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # Stochastic class for calculating the Stochastic oscillator.
    class Stochastic < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInPriceMixin
      include SignalCatcher::Indicators::Shared::MaTypesMixin

      register_setting :slow_k_period, default: 1, type: Integer, min: 0, max: 100
      register_setting :fast_k_period, default: 14, type: Integer, min: 0, max: 100
      register_setting :slow_d_period, default: 3, type: Integer, min: 0, max: 100
      register_setting :slow_k_ma, default: :sma, type: Symbol, enum: FULL_MA_TYPES_LIST
      register_setting :slow_d_ma, default: :sma, type: Symbol, enum: FULL_MA_TYPES_LIST

      private

      def talib_function_name
        'STOCH'
      end

      # Configures the parameters for the Stochastic oscillator.
      # @param c_function [TaLib::Function] The TaLib function to configure parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_int(0, fast_k_period)
        c_function.opt_int(1, slow_k_period)
        c_function.opt_int(2, find_ma_klass(slow_k_ma))
        c_function.opt_int(3, slow_d_period)
        c_function.opt_int(4, find_ma_klass(slow_d_ma))
      end

      # The number of output arrays for Stochastic (out_slow_k, out_slow_d).
      # @return [Integer] The number of outputs.
      def output_count
        2
      end
    end
  end
end
