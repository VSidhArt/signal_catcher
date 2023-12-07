# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Indicators::Shared::PrepareIndicatorDataInPriceMixin do
  include described_class

  let(:klines) do
    [double('Kline', ohlcv: [1, 2, 3, 4, 5]),
     double('Kline', ohlcv: [10, 11, 12, 13, 14])]
  end
  let(:indicator) { double('Indicator', in_price: nil) }

  before do
    allow(self).to receive(:klines).and_return(klines)
    allow(self).to receive(:multiplier).and_return(multiplier)
    allow(self).to receive(:indicator).and_return(indicator)
  end

  context 'when multiplier is 2' do
    let(:multiplier) { 2 }

    describe '#prepare_input' do
      it 'calls in_price on indicator with multiplied price data' do
        prepare_input
        expect(indicator).to have_received(:in_price).with(0, [2, 20], [4, 22], [6, 24], [8, 26], [5, 14], nil)
      end
    end
  end

  context 'when multiplier is 1' do
    let(:multiplier) { 1 }

    describe '#prepare_input' do
      it 'calls in_price on indicator with original price data' do
        prepare_input
        expect(indicator).to have_received(:in_price).with(0, [1, 10], [2, 11], [3, 12], [4, 13], [5, 14], nil)
      end
    end
  end
end
