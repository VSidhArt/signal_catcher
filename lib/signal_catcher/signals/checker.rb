# frozen_string_literal: true

module SignalCatcher
  module Signals
    class Checker
      CONDITIONS = {
        crossing_below: 'CrossingBelow',
        crossing_above: 'CrossingAbove',
        less: 'LessThan',
        less_or_equal: 'LessThanOrEqual',
        equal: 'Equal',
        greater_or_equal: 'GreaterThanOrEqual',
        greater: 'GreaterThan'
      }.freeze

      def self.call(moving_line:, relative_value:, condition:)
        raise ArgumentError, 'Invalid condition' unless moving_line.is_a?(Array)

        strategy_class = get_strategy_class(condition)
        strategy = strategy_class.new(moving_line, relative_value)
        strategy.check
      end

      def self.get_strategy_class(condition)
        strategy_name = CONDITIONS[condition]
        raise ArgumentError, "Unknown condition: #{condition}" unless strategy_name

        SignalCatcher::Signals::Conditions.const_get(strategy_name)
      end
    end
  end
end
