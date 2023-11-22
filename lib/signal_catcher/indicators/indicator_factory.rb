# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # IndicatorFactory is responsible for creating instances of various indicator
    # types based on provided parameters.
    class IndicatorFactory
      INDICATORS = {
        'adx' => SignalCatcher::Indicators::Adx,
        'b_bands_percent' => SignalCatcher::Indicators::BBandsPercent,
        'b_bands' => SignalCatcher::Indicators::BBands,
        'cci' => SignalCatcher::Indicators::Cci,
        'heikin_ashi' => SignalCatcher::Indicators::HeikinAshi,
        'macd' => SignalCatcher::Indicators::Macd,
        'rsi' => SignalCatcher::Indicators::Rsi,
        'stochastic' => SignalCatcher::Indicators::Stochastic
      }.freeze

      # Creates an instance of the specified indicator type.
      # @param indicator_type [String] the type of the indicator to create.
      # @param options [Hash] options for creating the indicator instance.
      # @return [Object] an instance of the specified indicator type.
      def self.create(indicator_type, options = {})
        if indicator_type == 'ma_cross'
          create_ma_cross_indicator(options)
        elsif INDICATORS.key?(indicator_type)
          INDICATORS[indicator_type].new(**options)
        else
          raise "Unknown indicator type: #{indicator_type}"
        end
      end

      # Creates a moving average cross indicator.
      # @param options [Hash] options for creating the ma_cross indicator instance.
      # @return [Object] an instance of the ma_cross indicator.
      def self.create_ma_cross_indicator(options)
        ma_type = options.dig(:indicator_params, :ma_type)
        case ma_type
        when 'sma' then SignalCatcher::Indicators::Sma.new(**options)
        when 'ema' then SignalCatcher::Indicators::Ema.new(**options)
        else
          raise "Unknown ma cross type: #{ma_type}"
        end
      end
    end
  end
end
