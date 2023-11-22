# frozen_string_literal: true

module SignalCatcher
  module Signals
    class Macd < BaseSignal
      register_setting :condition, type: Symbol, enum: %i[crossing_below crossing_above]
      register_setting :line_condition, type: Symbol, enum: %i[less greater]
      register_setting :value, type: Integer, default: 0

      def check!
        @klines.each_cons(2) do |subarray|
          macd_line, macd_signal_line = fetch_indicator_lines(@klines)

          result =
            SignalCatcher::Signals::Checker.call(
              moving_line: macd_line,
              relative_value: value,
              condition: line_condition
            ) &&
            SignalCatcher::Signals::Checker.call(
              moving_line: macd_line,
              relative_value: macd_signal_line,
              condition: condition
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
