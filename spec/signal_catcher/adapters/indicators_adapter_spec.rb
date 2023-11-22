# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Adapters::IndicatorsAdapter do
  describe '#call' do
    subject { described_class.new(indicator_type, indicator_params).call }

    context 'when indicator type is not ma_cross' do
      let(:indicator_type) { 'rsi' }
      let(:indicator_params) { {length: 14, source: 'close'} }

      it 'returns a hash with a single indicator key and its parameters' do
        expect(subject).to eq({'rsi_length_14_source_close' => {length: 14, source: 'close'}})
      end
    end

    context 'when indicator type is ma_cross' do
      let(:indicator_type) { 'ma_cross' }
      let(:indicator_params) do
        {
          ma_type: 'sma',
          time_period_first: 10,
          time_period_second: 20,
          source: 'close'
        }
      end

      it 'returns a hash with two indicator keys and their parameters' do
        expected_result = {
          'ma_cross_ma_type_sma_source_close_time_period_10' => {
            ma_type: 'sma', source: 'close', time_period: 10
          },
          'ma_cross_ma_type_sma_source_close_time_period_20' => {
            ma_type: 'sma', source: 'close', time_period: 20
          }
        }
        expect(subject).to eq(expected_result)
      end
    end
  end
end
