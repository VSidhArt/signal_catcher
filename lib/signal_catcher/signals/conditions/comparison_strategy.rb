# frozen_string_literal: true

module SignalCatcher
  module Signals
    module Conditions
      class ComparisonStrategy
        def initialize(moving_line, relative_value)
          @moving_line = moving_line
          @relative_value = relative_value
        end

        def check
          raise NotImplementedError, 'Subclasses must implement a check method'
        end

        protected

        def comparison(operation)
          if @relative_value.is_a?(Array)
            arrays_comparision(operation)
          else
            @moving_line.last.to_f.public_send(operation, @relative_value.to_f)
          end
        end

        private

        def arrays_comparision(operation)
          @moving_line.zip(@relative_value).all? do |moving_value, base_value|
            next false if moving_value.nil? || base_value.nil?

            moving_value.to_f.public_send(operation, base_value.to_f)
          end
        end

        def ensure_array(value)
          value.is_a?(Array) ? value : Array.new(@moving_line.size, value)
        end
      end
    end
  end
end
