# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # BBands class for calculating the Bollinger Bands indicator.
    class BBands < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInRealMixin
      include SignalCatcher::Indicators::Shared::MaTypesMixin

      register_setting :ma_type, default: :sma, type: Symbol, enum: FULL_MA_TYPES_LIST
      register_setting :ohlcv_value, default: :close, type: Symbol, enum: FULL_OHLVC_LIST
      register_setting :time_period, default: 20, type: Integer, min: 1, max: 151
      register_setting :deviations_up, default: 1, type: Integer, min: 1, max: 10
      register_setting :deviations_down, default: 1, type: Integer, min: 1, max: 10

      private

      def talib_function_name
        'BBANDS'
      end

      # Sets the parameters for the Bollinger Bands indicator.
      # @param c_function [TaLib::Function] The TaLib function to set parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_int(0, time_period)
        c_function.opt_real(1, deviations_up)
        c_function.opt_real(2, deviations_down)
        c_function.opt_int(3, find_ma_klass(ma_type))
      end

      # The number of output arrays (upper_band, middle_band, lower_band) for Bollinger Bands.
      # @return [Integer] The number of outputs.
      def output_count
        3
      end

      # The multiplier used for the output values of the Bollinger Bands.
      # @return [Integer] The multiplier value.
      def multiplier
        100_000_000
      end
    end
  end
end
