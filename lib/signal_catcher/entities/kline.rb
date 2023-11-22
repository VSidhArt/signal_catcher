# frozen_string_literal: true

module SignalCatcher
  module Entities
    class Kline
      attr_reader :ohlcv, :signal_storage, :open_time

      # @param Array [[open_time, open, high, low, close, volume]]
      def self.build(raw_data)
        raw_data.map { |kline_data| new(open_time: kline_data[0], ohlcv: kline_data[1..5]) }
      end

      def initialize(open_time:, ohlcv:)
        @ohlcv = ohlcv.map(&:to_f)
        @open_time = open_time.to_i
        @indicator_storage = {}
        @signal_storage = {}
      end

      def open
        @ohlcv[0]
      end

      def high
        @ohlcv[1]
      end

      def low
        @ohlcv[2]
      end

      def close
        @ohlcv[3]
      end

      def volume
        @ohlcv[4]
      end

      def set_indicator_result(indicator_key, indicator_result)
        @indicator_storage[indicator_key] = indicator_result
      end

      def indicator_result(indicator_key)
        @indicator_storage[indicator_key]
      end

      def set_signal_result(strategy_hash, signal_result)
        @signal_storage[strategy_hash] = signal_result
      end

      def signals_results(strategy_hashes)
        @signal_storage.slice(*strategy_hashes)
      end

      def signal_result(strategy_hashe)
        @signal_storage[strategy_hashe]
      end

      def human_open_time
        Time.at(open_time / 1000)
      end
    end
  end
end
