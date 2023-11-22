# frozen_string_literal: true

module SignalCatcher
  module Signals
    class BaseSignal
      FULL_CONDITIONS_LIST = %i[less less_or_equal equeal greater_or_equal greater crossing_below crossing_above].freeze
      include SignalCatcher::Utils::Configurable

      def initialize(klines:, signal_params:, strategy_hash:, indicator_keys:)
        initialize_with_config(signal_params)
        @klines = klines
        @signal_params = signal_params
        @strategy_hash = strategy_hash
        @indicator_keys = indicator_keys
      end
    end
  end
end
