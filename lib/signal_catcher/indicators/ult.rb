# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # Ult class for calculating the Ultimate Oscillator.
    class Ult < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInPriceMixin

      register_setting :first_period, default: 7, type: Integer, min: 1, max: 100
      register_setting :second_period, default: 14, type: Integer, min: 1, max: 100
      register_setting :third_period, default: 28, type: Integer, min: 1, max: 100

      private

      def talib_function_name
        'ULTOSC'
      end

      # Configures the parameters for the Ultimate Oscillator.
      # @param c_function [TaLib::Function] The TaLib function to configure parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_int(0, first_period)
        c_function.opt_int(1, second_period)
        c_function.opt_int(2, third_period)
      end

      # The multiplier used for the Ultimate Oscillator output values.
      # @return [Integer] The multiplier value.
      def multiplier
        100
      end
    end
  end
end
