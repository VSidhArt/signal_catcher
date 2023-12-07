# frozen_string_literal: true

module SignalCatcher
  module Indicators
    # Base class for indicators, providing a common structure and methods.
    class BaseIndicator
      FULL_OHLVC_LIST = %i[open close high low].freeze
      FULL_MA_TYPES_LIST = %i[sma ema wma dema tema trima kama mama t3].freeze

      include SignalCatcher::Utils::Configurable

      attr_reader :klines, :indicator

      # Initializes the BaseIndicator with klines, indicator parameters, and an indicator key.
      # @param klines [Array] The klines data.
      # @param indicator_params [Hash] Configuration parameters for the indicator.
      # @param indicator_key [String] Key to identify the indicator.
      def initialize(klines:, indicator_params:, indicator_key:)
        initialize_with_config(indicator_params)
        @klines = klines
        @indicator = initialize_indicator
        @indicator_key = indicator_key
      end

      # Executes the calculation process for the indicator.
      def calculate!
        prepare_input
        prepare_output
        @indicator.call(0, klines.length - 1)
        save_results_to_klines
      end

      private

      # Initializes the specific indicator.
      def initialize_indicator
        c_function = TaLib::Function.new(talib_function_name)
        configure_indicator_parameters(c_function)
        c_function
      end

      # Prepares the indicator with necessary configurations. Must be implemented in subclasses.
      def prepare_input
        raise NotImplementedError, 'prepare_input must be implemented in subclasses'
      end

      def configure_indicator_parameters
        raise NotImplementedError, 'configure_indicator_parameters must be implemented in subclasses'
      end

      # Prepares the output storage for indicator results.
      def prepare_output
        @output_storages = prepare_output_storages
        @output_storages.each.with_index do |storage, index|
          @indicator.out_real(index, storage)
        end
      end

      # Saves the calculated results to each kline.
      def save_results_to_klines
        output_storage = @output_storages.size == 1 ? @output_storages.first : prepare_outputs_results
        save_output_to_klines(output_storage)
      end

      # Prepares the results from multiple output storages.
      def prepare_outputs_results
        @output_storages.transpose.map(&:flatten).filter_map do |output|
          output.map { |value| value / multiplier } if output.any?
        end
      end

      # Saves the output data to each kline.
      def save_output_to_klines(output_storage)
        fix_output_nils(output_storage).each.with_index do |result, index|
          klines[index].set_indicator_result(@indicator_key, result)
        end
      end

      # Fixes nil values in the output storage, becouse ta_lib library puts nils to the end
      def fix_output_nils(arr)
        nil_subarrays, non_nil_subarrays = arr.partition(&:nil?)
        nil_subarrays.push(*Array.new(klines.size - arr.size, nil))
        nil_subarrays + non_nil_subarrays
      end

      # Prepares the output storages for the indicator results.
      def prepare_output_storages
        Array.new(output_count) { Array.new(klines.length) }
      end

      # Returns the multiplier for the indicator results.
      # Some indicators works uncorrect with small prices like 0.0000000001 and we need to multiple it.
      def multiplier
        1.0
      end

      # Returns the number of outputs for the indicator.
      # Usually it 1, but for some indicators it can be more
      def output_count
        1
      end
    end
  end
end
