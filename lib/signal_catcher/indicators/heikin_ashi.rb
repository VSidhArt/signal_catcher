# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # HeikinAshi class for calculating the Heikin-Ashi indicator.
    # Here we not use ta_lib library
    class HeikinAshi
      include SignalCatcher::Utils::Configurable

      attr_reader :klines

      # Initializes the HeikinAshi indicator with klines and indicator parameters.
      # @param klines [Array] The klines data.
      # @param indicator_params [Hash] Configuration parameters for the indicator.
      # @param indicator_key [String] Key to identify the indicator.
      def initialize(klines:, indicator_params:, indicator_key:)
        initialize_with_config(indicator_params)
        @klines = klines
        @indicator_key = indicator_key
      end

      # Calculates the Heikin-Ashi indicator values.
      def calculate!
        last_ha_kline = {}

        klines.each do |kline|
          ha_values = calculate_heikin_ashi_values(kline, last_ha_kline)
          last_ha_kline = ha_values
          set_heikin_ashi_result(kline, ha_values)
        end
      end

      private

      # Calculates Heikin-Ashi values for a single kline.
      # @param kline [Kline] The current kline data.
      # @param last_ha_kline [Hash] The previous Heikin-Ashi kline data.
      # @return [Hash] The calculated Heikin-Ashi values.
      def calculate_heikin_ashi_values(kline, last_ha_kline)
        ha_open = calculate_ha_open(kline, last_ha_kline)
        ha_close = calculate_ha_close(kline)
        ha_high = [kline.high, ha_open, ha_close].max
        ha_low = [kline.low, ha_open, ha_close].min

        {open: ha_open, high: ha_high, low: ha_low, close: ha_close}
      end

      # Calculates the Heikin-Ashi open value.
      def calculate_ha_open(kline, last_ha_kline)
        if last_ha_kline[:open]
          ((last_ha_kline[:open] + last_ha_kline[:close]) / 2).round(16)
        else
          ((kline.open + kline.close) / 2).round(16)
        end
      end

      # Calculates the Heikin-Ashi close value.
      def calculate_ha_close(kline)
        ((kline.open + kline.high + kline.low + kline.close) / 4).round(16)
      end

      # Sets the Heikin-Ashi indicator result for a kline.
      def set_heikin_ashi_result(kline, ha_values)
        kline.set_indicator_result(@indicator_key, ha_values)
      end
    end
  end
end
