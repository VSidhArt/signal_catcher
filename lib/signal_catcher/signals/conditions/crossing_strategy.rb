# frozen_string_literal: true

module SignalCatcher
  module Signals
    module Conditions
      class CrossingStrategy < ComparisonStrategy
        def initialize(moving_line, relative_value)
          super
          @relative_value = ensure_array(relative_value)
        end

        protected

        def previous_and_current_values
          @moving_line.each_cons(2).zip(@relative_value.each_cons(2)).select do |(prev_mv, curr_mv), (prev_rv, curr_rv)|
            [prev_mv, curr_mv, prev_rv, curr_rv].none?(&:nil?)
          end
        end
      end
    end
  end
end
