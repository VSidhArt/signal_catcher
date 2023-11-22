# frozen_string_literal: true

module SignalCatcher
  module Signals
    # SignalFactory is responsible for creating instances of various signal
    # types based on provided parameters.
    class SignalFactory
      # Mapping of indicator types to their corresponding signal classes.
      SIGNAL_CLASSES = {
        'adx' => SignalCatcher::Signals::Adx,
        'b_bands_percent' => SignalCatcher::Signals::BBandsPercent,
        'cci' => SignalCatcher::Signals::Cci,
        'heikin_ashi' => SignalCatcher::Signals::HeikinAshi,
        'macd' => SignalCatcher::Signals::Macd,
        'rsi' => SignalCatcher::Signals::Rsi,
        'stochastic' => SignalCatcher::Signals::Stochastic,
        'ma_cross' => SignalCatcher::Signals::MaCross
      }.freeze

      # Creates an instance of the specified signal type.
      # @param indicator_type [String] the type of the indicator for which to create the signal.
      # @param options [Hash] options for creating the signal instance.
      # @return [Object] an instance of the specified signal type.
      def self.create(indicator_type, options = {})
        signal_class = SIGNAL_CLASSES[indicator_type]
        raise "Unknown signal for indicator type: #{indicator_type}" unless signal_class

        signal_class.new(**options)
      end
    end
  end
end
