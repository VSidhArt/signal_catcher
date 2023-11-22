# frozen_string_literal: true

module SignalCatcher
  module Signals
    class Stochastic < BaseSignal
      register_setting :condition, type: Symbol, enum: FULL_CONDITIONS_LIST
      register_setting :line_condition, type: Symbol, enum: %i[crossing_below crossing_above]
      register_setting :value, type: Integer, min: 1, max: 100

      def check!
        @klines.each_cons(2) do |subarray|
          slow_k_line, slow_d_line = fetch_indicator_lines(subarray)

          result =
            SignalCatcher::Signals::Checker.call(
              moving_line: slow_k_line,
              relative_value: value,
              condition: condition
            ) &&
            SignalCatcher::Signals::Checker.call(
              moving_line: slow_k_line,
              relative_value: slow_d_line,
              condition: line_condition
            )

          subarray.last.set_signal_result(@strategy_hash, result)
        end
      end

      def fetch_indicator_lines(klines)
        indicator_key = @indicator_keys.first

        klines.map do |kline|
          indicator = kline.indicator_result(indicator_key)
          [indicator[0], indicator[1]]
        end.transpose
      end
    end
  end
end
