# frozen_string_literal: true

module SignalCatcher
  module Signals
    module Conditions
      class GreaterThan < ComparisonStrategy
        def check
          comparison(:>)
        end
      end
    end
  end
end
