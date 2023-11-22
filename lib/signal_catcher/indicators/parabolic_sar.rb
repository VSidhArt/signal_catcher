# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # ParabolicSar class for calculating the Parabolic SAR indicator.
    class ParabolicSar < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInPriceMixin
      register_setting :acceleration_factor, default: 0.02, type: Float, min: 0.01, max: 1.0
      register_setting :af_maximum, default: 0.2, type: Float, min: 0.1, max: 10.0

      private

      def talib_function_name
        'SAR'
      end

      # Configures the parameters for the Parabolic SAR indicator.
      # @param c_function [TaLib::Function] The TaLib function to configure parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_real(0, acceleration_factor)
        c_function.opt_real(1, af_maximum)
      end
    end
  end
end
