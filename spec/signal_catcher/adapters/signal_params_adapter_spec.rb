# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Adapters::SignalParamsAdapter do
  describe '.call' do
    context 'when trigger and line_trigger are present' do
      let(:params) do
        {
          trigger: {condition: 'greater_than', value: 10},
          line_trigger: {condition: 'less_than', value: 5}
        }
      end

      it 'sets condition, line_condition, and value correctly' do
        result = described_class.call(params)
        expect(result[:condition]).to eq('greater_than')
        expect(result[:line_condition]).to eq('less_than')
        expect(result[:value]).to eq(10)
      end
    end

    context 'when only trigger is present' do
      let(:params) { {trigger: {condition: 'equal_to', value: 15}} }

      it 'sets condition and value correctly, and line_condition to nil' do
        result = described_class.call(params)
        expect(result[:condition]).to eq('equal_to')
        expect(result[:value]).to eq(15)
        expect(result[:line_condition]).to be_nil
      end
    end

    context 'when only line_trigger is present' do
      let(:params) { {line_trigger: {condition: 'not_equal_to', value: 20}} }

      it 'sets line_condition and value correctly, and condition to nil' do
        result = described_class.call(params)
        expect(result[:line_condition]).to eq('not_equal_to')
        expect(result[:value]).to eq(20)
        expect(result[:condition]).to be_nil
      end
    end

    context 'when trigger has no value but line_trigger has' do
      let(:params) do
        {
          trigger: {condition: 'greater_than'},
          line_trigger: {condition: 'less_than', value: 5}
        }
      end

      it 'sets value from line_trigger' do
        result = described_class.call(params)
        expect(result[:value]).to eq(5)
      end
    end

    context 'when neither trigger nor line_trigger is present' do
      let(:params) { {} }

      it 'does not modify params' do
        result = described_class.call(params)
        expect(result).to eq(params)
      end
    end
  end
end
