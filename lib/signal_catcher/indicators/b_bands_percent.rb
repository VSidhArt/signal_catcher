# frozen_string_literal: true

module SignalCatcher
  module Indicators
    class BBandsPercent < BBands
      private

      # Prepares the output results for Bollinger Bands Percentage calculation.
      def prepare_outputs_results
        move_trailing_nil_to_beginning(@output_storages.transpose.map(&:flatten))
          .filter_map.with_index do |output, index|
            calculate_bbands_percent(output, index) if output.compact.any?
          end
      end

      # Moves trailing nils to the beginning of the array.
      # @param arr [Array] The array to process.
      # @return [Array] The processed array with trailing nils moved to the beginning.
      def move_trailing_nil_to_beginning(arr)
        nil_subarrays, non_nil_subarrays = arr.partition { |subarray| subarray.all?(&:nil?) }
        nil_subarrays + non_nil_subarrays
      end

      # Calculates the Bollinger Bands percentage.
      # @param output [Array] The output array containing upper and lower band values.
      # @param index [Integer] The index of the kline.
      # @return [Float] The Bollinger Bands percentage value.
      def calculate_bbands_percent(output, index)
        current_price = klines[index].public_send(@ohlcv_value)
        ub, _, lb = output.map { |value| value / multiplier }
        ((current_price - lb) / (ub - lb)).round(5).to_f
      end
    end
  end
end
