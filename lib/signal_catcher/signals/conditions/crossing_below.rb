# frozen_string_literal: true

module SignalCatcher
  module Signals
    module Conditions
      class CrossingBelow < CrossingStrategy
        def check
          previous_and_current_values.any? do |(prev_mv, curr_mv), (prev_rv, curr_rv)|
            prev_mv <= prev_rv && curr_mv > curr_rv
          end
        end
      end
    end
  end
end
