# frozen_string_literal: true

module SignalCatcher
  module Signals
    class Mfi < BaseSignal
      include SignalCatcher::Signals::ComperativeSignalMixin

      register_setting :condition, type: Symbol, enum: FULL_CONDITIONS_LIST
      register_setting :value, type: Integer, min: 1, max: 100

      def check!
        comperative_signal
      end
    end
  end
end
