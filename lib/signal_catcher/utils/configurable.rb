# frozen_string_literal: true

# This module provides a mixin to allow easy configuration settings registration
# with type casting and validations for any class.
module SignalCatcher
  module Utils
    module Configurable
      # When included, it adds instance methods to the base class and extends it
      # with class methods.
      # @param base [Class] The class that includes this module
      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      # Module containing class methods to be extended in the base class.
      module ClassMethods
        # Registers a configuration setting with type casting and validations.
        # @param name [Symbol] The name of the setting
        # @param type [Class] The data type of the setting
        # @param default [Object] Default value of the setting, nil by default
        # @param validations [Hash] A hash containing validations like :min, :max, :enum
        def register_setting(name, type:, default: nil, **validations)
          define_getter(name, default)
          define_setter(name, type, validations)
        end

        private

        # Defines a getter method for a setting.
        # @param name [Symbol] The name of the setting
        # @param default [Object] Default value of the setting
        def define_getter(name, default)
          define_method(name) do
            instance_variable_get("@#{name}") || default
          end
        end

        # Defines a setter method for a setting with type casting and validations.
        # @param name [Symbol] The name of the setting
        # @param type [Class] The data type of the setting
        # @param validations [Hash] A hash containing validations
        def define_setter(name, type, validations)
          define_method("#{name}=") do |value|
            raise ArgumentError, "Nil value for #{name}." if value.nil? && default.nil?

            casted_value = cast_type(value, type)
            validate_setting(name, casted_value, type, validations)
            instance_variable_set("@#{name}", casted_value)
          end
        end
      end

      # Module containing instance methods to be included in the base class.
      module InstanceMethods
        private

        # Initializes the instance with a configuration hash.
        # @param config [Hash] A hash containing configuration settings
        def initialize_with_config(config)
          config.each do |key, value|
            public_send("#{key}=", value) if respond_to?("#{key}=")
          end
        end

        # Casts a value to a specified data type.
        # @param value [Object] The value to be cast
        # @param data_type [Class] The type to which the value is to be cast
        # @return [Object] The value cast to the specified type
        def cast_type(value, data_type)
          case data_type.to_s
          when 'Symbol' then String(value).to_sym
          when 'Integer' then value.to_i
          when 'Float' then Float(value)
          when 'String' then String(value)
          when 'BigDecimal' then BigDecimal(value)
          else value
          end
        rescue StandardError
          value
        end

        # Validates the setting's type and value according to provided validations.
        # @param name [Symbol] The name of the setting
        # @param value [Object] The value to validate
        # @param data_type [Class] The expected data type of the setting
        # @param validations [Hash] A hash containing validations like :min, :max, :enum
        def validate_setting(name, value, data_type, validations)
          validate_setting_type(name, value, data_type)
          validate_setting_value(name, value, validations)
        end

        # Validates that a value is of the expected data type.
        # @param name [Symbol] The name of the setting
        # @param value [Object] The value to validate
        # @param data_type [Class] The expected data type of the setting
        def validate_setting_type(name, value, data_type)
          return if value.is_a?(data_type)

          raise ArgumentError, "Invalid data type for #{name}. Expected #{data_type}, got #{value.class} (#{value})"
        end

        # Applies custom validations to the value.
        # @param name [Symbol] The name of the setting
        # @param value [Object] The value to validate
        # @param validations [Hash] A hash containing validations like :min, :max, :enum
        def validate_setting_value(name, value, validations)
          validations.each do |validation_key, validation_value|
            send("validate_#{validation_key}", name, value, validation_value)
          end
        end

        # Validates the minimum value constraint.
        # @param name [Symbol] The setting name
        # @param value [Object] The value to validate
        # @param min_value [Numeric] The minimum allowed value
        def validate_min(name, value, min_value)
          return if value >= min_value

          raise ArgumentError, "Value for #{name} must be greater than #{min_value}"
        end

        # Validates the maximum value constraint.
        # @param name [Symbol] The setting name
        # @param value [Object] The value to validate
        # @param max_value [Numeric] The maximum allowed value
        def validate_max(name, value, max_value)
          return if value <= max_value

          raise ArgumentError, "Value for #{name} must be less than #{max_value}"
        end

        # Validates the enum value constraint.
        # @param name [Symbol] The setting name
        # @param value [Object] The value to validate
        # @param enum_values [Array] The array of allowed values
        def validate_enum(name, value, enum_values)
          return if enum_values.include?(value)

          raise ArgumentError, "Value for #{name} must be one of #{enum_values}"
        end
      end
    end
  end
end
