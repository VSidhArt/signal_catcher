# frozen_string_literal: true

module SignalCatcher
  module Signals
    class ParabolicSar < BaseSignal
      register_setting :condition, type: Symbol, enum: %i[crossing_below crossing_above]

      def check!
        @klines.each_cons(2) do |subarray|
          kline_line, indicator_line = fetch_indicator_lines(subarray)

          result = SignalCatcher::Signals::Checker.call(
            moving_line: kline_line,
            relative_value: indicator_line,
            condition: condition
          )

          subarray.last.set_signal_result(@strategy_hash, result)
        end
      end

      def fetch_indicator_lines(klines)
        klines.map do |kline|
          [kline.close, kline.indicator_result(@indicator_keys.first)]
        end.transpose
      end
    end
  end
end
