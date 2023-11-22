# frozen_string_literal: true

module SignalCatcher
  module Signals
    class MaCross < BaseSignal
      register_setting :condition, type: Symbol, enum: FULL_CONDITIONS_LIST

      def check!
        @klines.each_cons(2) do |klines|
          prev_kline, kline = klines

          moving_line =
            [prev_kline.indicator_result(@indicator_keys.first), kline.indicator_result(@indicator_keys.first)]
          relative_line =
            [prev_kline.indicator_result(@indicator_keys.last), kline.indicator_result(@indicator_keys.last)]

          result =
            SignalCatcher::Signals::Checker
            .call(moving_line: moving_line, relative_value: relative_line, condition: condition)

          kline.set_signal_result(@strategy_hash, result)
        end
      end
    end
  end
end
