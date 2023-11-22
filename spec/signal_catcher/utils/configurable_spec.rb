# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Utils::Configurable do
  subject(:configurable_instance) { configurable_class.new }

  let(:configurable_class) do
    Class.new do
      include SignalCatcher::Utils::Configurable

      register_setting :integer_setting, type: Integer, default: 10, min: 1, max: 100
      register_setting :string_setting, type: String
      register_setting :enum_setting, type: Symbol, enum: %i[one two three]
    end
  end

  describe '#register_setting' do
    it 'creates getter and setter methods for a setting' do
      expect(configurable_instance).to respond_to(:integer_setting)
      expect(configurable_instance).to respond_to(:integer_setting=)
    end

    it 'returns the default value if not set' do
      expect(configurable_instance.integer_setting).to eq(10)
    end
  end

  describe 'setting values' do
    it 'allows setting and getting a valid integer value' do
      configurable_instance.integer_setting = 20
      expect(configurable_instance.integer_setting).to eq(20)
    end

    it 'raises error for invalid integer value' do
      expect { configurable_instance.integer_setting = 101 }.to raise_error(ArgumentError)
    end

    it 'allows setting and getting a valid string value' do
      configurable_instance.string_setting = 'test'
      expect(configurable_instance.string_setting).to eq('test')
    end

    it 'raises error for invalid enum value' do
      expect { configurable_instance.enum_setting = :four }.to raise_error(ArgumentError)
    end
  end

  describe 'type casting' do
    it 'casts string to integer' do
      configurable_instance.integer_setting = '30'
      expect(configurable_instance.integer_setting).to be_a(Integer)
      expect(configurable_instance.integer_setting).to eq(30)
    end

    it 'casts to the correct type' do
      configurable_instance.string_setting = 100
      expect(configurable_instance.string_setting).to be_a(String)
      expect(configurable_instance.string_setting).to eq('100')
    end
  end
end
