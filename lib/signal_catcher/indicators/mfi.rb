# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # Mfi class for calculating the Money Flow Index.
    class Mfi < BaseIndicator
      include SignalCatcher::Indicators::Shared::PrepareIndicatorDataInPriceMixin

      register_setting :time_period, default: 20, type: Integer, min: 1, max: 100

      private

      def talib_function_name
        'MFI'
      end

      # Configures the parameters for the MFI indicator.
      # @param c_function [TaLib::Function] The TaLib function to configure parameters on.
      def configure_indicator_parameters(c_function)
        c_function.opt_int(0, time_period)
      end
    end
  end
end
