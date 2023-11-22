# frozen_string_literal: true

module SignalCatcher
  module Adapters
    class SignalParamsAdapter
      # Adapt the signal parameters, extract certain values.
      # @param params [Hash] Original parameters hash.
      # @return [Hash] Adapted parameters hash.
      def self.call(params)
        adapted_params = params.dup

        adapted_params[:condition] = extract_condition(params, :trigger) if params.key?(:trigger)
        adapted_params[:line_condition] = extract_condition(params, :line_trigger) if params.key?(:line_trigger)
        adapted_params[:value] = extract_value(params) if params.key?(:trigger) || params.key?(:line_trigger)

        adapted_params
      end

      def self.extract_condition(params, key)
        params.dig(key, :condition)
      end

      def self.extract_value(params)
        params.dig(:trigger, :value) || params.dig(:line_trigger, :value)
      end
    end
  end
end
