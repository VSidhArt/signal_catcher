# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Indicators::IndicatorFactory do
  describe '.create' do
    let(:common_options) { {klines: [1, 2, 3], indicator_key: 'test_key', indicator_params: {}} }

    shared_examples 'indicator creation' do |indicator_type, indicator_class|
      it "creates a #{indicator_class} instance for #{indicator_type} type" do
        options = common_options.merge(indicator_params: {some_param: 'value'})
        expect(described_class.create(indicator_type, options)).to be_an_instance_of(indicator_class)
      end
    end

    it_behaves_like 'indicator creation', 'adx', SignalCatcher::Indicators::Adx
    it_behaves_like 'indicator creation', 'b_bands_percent', SignalCatcher::Indicators::BBandsPercent
    it_behaves_like 'indicator creation', 'b_bands', SignalCatcher::Indicators::BBands
    it_behaves_like 'indicator creation', 'cci', SignalCatcher::Indicators::Cci
    it_behaves_like 'indicator creation', 'heikin_ashi', SignalCatcher::Indicators::HeikinAshi
    it_behaves_like 'indicator creation', 'macd', SignalCatcher::Indicators::Macd
    it_behaves_like 'indicator creation', 'rsi', SignalCatcher::Indicators::Rsi
    it_behaves_like 'indicator creation', 'stochastic', SignalCatcher::Indicators::Stochastic

    context 'when ma_cross type' do
      let(:ma_cross_options) do
        common_options.merge(indicator_params: common_options[:indicator_params].merge(ma_type: ma_type))
      end

      context 'with sma type' do
        let(:ma_type) { 'sma' }

        it 'creates a Sma instance' do
          expect(described_class.create('ma_cross', ma_cross_options))
            .to be_an_instance_of(SignalCatcher::Indicators::Sma)
        end
      end

      context 'with ema type' do
        let(:ma_type) { 'ema' }

        it 'creates an Ema instance' do
          expect(described_class.create('ma_cross', ma_cross_options))
            .to be_an_instance_of(SignalCatcher::Indicators::Ema)
        end
      end

      context 'with an unknown type' do
        let(:ma_type) { 'unknown' }

        it 'raises an error' do
          expect do
            described_class.create('ma_cross', ma_cross_options)
          end.to raise_error(RuntimeError, /Unknown ma cross type/)
        end
      end
    end

    it 'raises an error for unknown indicator type' do
      expect do
        described_class.create('unknown', common_options)
      end.to raise_error(RuntimeError, /Unknown indicator type/)
    end
  end
end
