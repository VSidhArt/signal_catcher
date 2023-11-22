# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Entities::Kline do
  describe '.build' do
    let(:raw_data) { [[1_622_476_800_000, '1.0', '2.0', '0.5', '1.5', '1000']] }

    it 'builds an array of Kline instances from raw data' do
      klines = described_class.build(raw_data)
      expect(klines).to all(be_a(described_class))
      expect(klines.first.open).to eq(1.0)
    end
  end

  describe '#set_indicator_result and #indicator_result' do
    let(:kline) { described_class.new(open_time: 1_622_476_800_000, ohlcv: ['1.0', '2.0', '0.5', '1.5', '1000']) }

    it 'sets and retrieves the indicator result' do
      kline.set_indicator_result(:rsi, 70.0)
      expect(kline.indicator_result(:rsi)).to eq(70.0)
    end
  end

  describe '#set_signal_result, #signals_results, and #signal_result' do
    let(:kline) { described_class.new(open_time: 1_622_476_800_000, ohlcv: ['1.0', '2.0', '0.5', '1.5', '1000']) }

    it 'sets and retrieves signal results' do
      kline.set_signal_result({strategy: 'abc'}, 'buy')
      expect(kline.signal_result({strategy: 'abc'})).to eq('buy')
      expect(kline.signals_results([{strategy: 'abc'}])).to eq({strategy: 'abc'} => 'buy')
    end
  end

  describe '#human_open_time' do
    let(:kline) { described_class.new(open_time: 1_622_476_800_000, ohlcv: ['1.0', '2.0', '0.5', '1.5', '1000']) }

    it 'returns the open time as a Time object' do
      expect(kline.human_open_time).to eq(Time.at(1_622_476_800_000 / 1000))
    end
  end
end
