# frozen_string_literal: true

module SignalCatcher
  module Signals
    module ComperativeSignalMixin
      def comperative_signal
        @klines.each_cons(2) do |klines_subarray|
          indicator_line =
            klines_subarray.map { |kline| kline.indicator_result(@indicator_keys.first) }

          result = SignalCatcher::Signals::Checker.call(
            moving_line: indicator_line,
            relative_value: value,
            condition: condition
          )

          klines_subarray.last.set_signal_result(@strategy_hash, result)
        end
      end
    end
  end
end
