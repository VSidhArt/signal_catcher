# frozen_string_literal: true

module SignalCatcher
  module Adapters
    # The IndicatorsAdapter class is responsible for adapting indicator parameters
    # based on the indicator type, primarily used to transform parameters for
    # different types of indicators and build key to store it.
    class IndicatorsAdapter
      # @return [String] the type of indicator
      attr_reader :indicator_type

      # @return [Hash] the parameters for the indicator
      attr_reader :indicator_params

      # Initializes the IndicatorsAdapter.
      # @param indicator_type [String] the type of indicator
      # @param indicator_params [Hash] the parameters for the indicator
      def initialize(indicator_type, indicator_params)
        @indicator_type = indicator_type
        @indicator_params = indicator_params
      end

      # Adapts indicator parameters based on the indicator type.
      # @return [Hash] adapted indicator parameters
      def call
        case indicator_type
        when 'ma_cross'
          adapt_ma_cross_params
        else
          {build_indicator_key(indicator_type, indicator_params) => indicator_params}
        end
      end

      private

      # Adapts parameters specifically for 'ma_cross' indicator type, becouse here we need to check two indicators.
      # @return [Hash] adapted parameters for ma_cross
      def adapt_ma_cross_params
        parse_ma_params.each_with_object({}) do |params, accumulator|
          indicator_key = build_indicator_key('ma_cross', params)
          accumulator[indicator_key] = params
        end
      end

      # Parses moving average parameters from the indicator parameters.
      # @return [Array<Hash>] parsed parameters for moving averages
      def parse_ma_params
        %i[time_period_first time_period_second].map do |time_period_key|
          transform_ma_params(time_period_key)
        end
      end

      # Transforms moving average parameters.
      # @param time_period_key [Symbol] the key representing the time period
      # @return [Hash] transformed moving average parameters
      def transform_ma_params(time_period_key)
        indicator_params
          .except(:time_period_first, :time_period_second)
          .merge(time_period: indicator_params[time_period_key])
      end

      # Builds an indicator key based on type and parameters.
      # @param type [String] the type of the indicator
      # @param params [Hash] the parameters for the indicator
      # @return [String] a unique key for the indicator
      def build_indicator_key(type, params)
        "#{type}_#{params.sort_by { |k, _v| k.to_s }.flatten.join('_')}"
      end
    end
  end
end
