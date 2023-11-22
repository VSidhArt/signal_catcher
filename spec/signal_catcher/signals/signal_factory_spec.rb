# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Signals::SignalFactory do
  describe '.create' do
    let(:common_options) do
      {
        klines: [1, 2, 3], # Mocked array of klines
        signal_params: {param1: 'value1'}, # Example signal parameters
        strategy_hash: 'test_strategy_hash', # Mocked strategy hash
        indicator_keys: %w[key1 key2]     # Mocked indicator keys
      }
    end

    shared_examples 'signal creation' do |indicator_type, signal_class|
      it "creates a #{signal_class} instance for #{indicator_type} type" do
        signal = described_class.create(indicator_type, common_options)
        expect(signal).to be_an_instance_of(signal_class)
      end
    end

    it_behaves_like 'signal creation', 'adx', SignalCatcher::Signals::Adx
    it_behaves_like 'signal creation', 'b_bands_percent', SignalCatcher::Signals::BBandsPercent
    it_behaves_like 'signal creation', 'cci', SignalCatcher::Signals::Cci
    it_behaves_like 'signal creation', 'heikin_ashi', SignalCatcher::Signals::HeikinAshi
    it_behaves_like 'signal creation', 'macd', SignalCatcher::Signals::Macd
    it_behaves_like 'signal creation', 'rsi', SignalCatcher::Signals::Rsi
    it_behaves_like 'signal creation', 'stochastic', SignalCatcher::Signals::Stochastic
    it_behaves_like 'signal creation', 'ma_cross', SignalCatcher::Signals::MaCross

    it 'raises an error for unknown indicator type' do
      expect do
        described_class.create('unknown', common_options)
      end.to raise_error(RuntimeError, /Unknown signal for indicator type/)
    end
  end
end
