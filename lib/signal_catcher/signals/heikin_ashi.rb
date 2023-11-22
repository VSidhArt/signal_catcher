# frozen_string_literal: true

module SignalCatcher
  module Signals
    class HeikinAshi < BaseSignal
      register_setting :condition, type: Symbol, enum: %i[less greater]
      register_setting :value, type: Integer, min: 1, max: 10

      def check!
        @klines.each_cons(value).with_index do |subarray, _index|
          open_line, close_line = fetch_indicator_lines(subarray)

          if open_line.all? && close_line.all?
            result = SignalCatcher::Signals::Checker.call(
              moving_line: open_line,
              relative_value: close_line,
              condition: condition
            )

            subarray.last.set_signal_result(@strategy_hash, result)
          else
            subarray.each { |kline| kline.set_signal_result(@strategy_hash, nil) }
          end
        end
      end

      def fetch_indicator_lines(klines)
        indicator_key = @indicator_keys.first
        klines.map do |kline|
          indicator = kline.indicator_result(indicator_key)
          [indicator&.dig(:ha_open), indicator&.dig(:ha_close)]
        end.transpose
      end
    end
  end
end
