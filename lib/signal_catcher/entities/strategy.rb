# frozen_string_literal: true

module SignalCatcher
  module Entities
    # The Strategy class represents a trading strategy with its indicators,
    # parameters, and signals. It is responsible for building strategy instances
    # from raw data, calculating indicators, and checking signals.
    class Strategy
      attr_reader :indicator_type, :indicator_params, :signal_params, :strategy_hash

      # Builds an array of Strategy instances from raw data.
      # @param raw_strategies [Array<Hash>] the raw strategy data
      # @return [Array<Strategy>] an array of built Strategy instances
      def self.build(raw_strategies)
        raw_strategies.map do |strategy|
          new(
            indicator_type: strategy[:indicator_type],
            indicator_params: strategy[:indicator_params],
            signal_params: adapt_signal_params(strategy[:signal_params]),
            strategy_hash: strategy[:strategy_hash]
          )
        end
      end

      # Adapts the signal parameters using the SignalParamsAdapter.
      # @param signal_params [Hash] original signal parameters
      # @return [Hash] adapted signal parameters
      def self.adapt_signal_params(signal_params)
        SignalCatcher::Adapters::SignalParamsAdapter.call(signal_params)
      end
      private_class_method :adapt_signal_params

      # @param indicator_type [String] the type of the indicator
      # @param indicator_params [Hash] parameters for the indicator
      # @param signal_params [Hash] parameters for the signals
      # @param strategy_hash [String] a unique hash representing the strategy
      def initialize(indicator_type:, indicator_params:, signal_params:, strategy_hash:)
        @strategy_hash = strategy_hash
        @indicator_type = indicator_type
        @indicator_params = indicator_params
        @signal_params = signal_params
      end

      # Calculates indicators for a collection of klines.
      # @param klines [Array<SignalCatcher::Entities::Kline>] an array of kline data
      def calculate_indicators!(klines)
        adapted_indicators.each do |indicator_key, params|
          next if klines.first.indicator_result(indicator_key)

          SignalCatcher::Indicators::IndicatorFactory.create(
            indicator_type,
            klines: klines,
            indicator_params: params,
            indicator_key: indicator_key
          ).calculate!
        end
      end

      # Checks signals for a collection of klines.
      # @param klines [Array<SignalCatcher::Entities::Kline>] an array of kline data
      def check_signals(klines)
        SignalCatcher::Signals::SignalFactory.create(
          indicator_type,
          klines: klines,
          signal_params: signal_params,
          strategy_hash: strategy_hash,
          indicator_keys: adapted_indicators.keys
        ).check!
      end

      private

      # Retrieves indicators for the strategy.
      # @return [Hash] a hash of indicators and their parameters
      def adapted_indicators
        @adapted_indicators ||= SignalCatcher::Adapters::IndicatorsAdapter.new(indicator_type, indicator_params).call
      end
    end
  end
end
