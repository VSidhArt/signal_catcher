# frozen_string_literal: true

module SignalCatcher
  module Signals
    module Conditions
      class Equal < ComparisonStrategy
        def check
          comparison(:==)
        end
      end
    end
  end
end
