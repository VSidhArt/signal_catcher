# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # Adx class for calculating the Average Directional Movement Index.
    class Adx < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInPriceMixin
      register_setting :time_period, default: 14, type: Integer, min: 1, max: 100

      private

      def talib_function_name
        'ADX'
      end

      # Configures the parameters for the ADX indicator.
      # @param c_function [TaLib::Function] The TaLib function to configure parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_int(0, time_period)
      end
    end
  end
end
