# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Indicators::Shared::PrepareIndicatorDataInRealMixin do
  include described_class

  let(:klines) { [double('Kline', close: 10), double('Kline', close: 20)] }
  let(:indicator) { double('Indicator', in_real: nil) }
  let(:ohlcv_value) { :close }

  before do
    allow(self).to receive(:klines).and_return(klines)
    allow(self).to receive(:multiplier).and_return(multiplier)
    allow(self).to receive(:ohlcv_value).and_return(ohlcv_value)
    allow(self).to receive(:indicator).and_return(indicator)
  end

  describe '#prepare_input' do
    context 'when multiplier is 2' do
      let(:multiplier) { 2 }

      it 'calls in_real on indicator with multiplied real data' do
        prepare_input
        expect(indicator).to have_received(:in_real).with(0, [20, 40])
      end
    end

    context 'when multiplier is 1' do
      let(:multiplier) { 1 }

      it 'calls in_real on indicator with prepared real data' do
        prepare_input
        expect(indicator).to have_received(:in_real).with(0, [10, 20])
      end
    end
  end
end
