# frozen_string_literal: true

module SignalCatcher
  module Signals
    class BBandsPercent < BaseSignal
      include SignalCatcher::Signals::ComperativeSignalMixin

      register_setting :condition, type: Symbol, enum: FULL_CONDITIONS_LIST
      register_setting :value, type: Integer, min: -2, max: 2

      def check!
        comperative_signal
      end
    end
  end
end
