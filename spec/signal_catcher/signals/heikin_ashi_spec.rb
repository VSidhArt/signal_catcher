# frozen_string_literal: true

RSpec.describe SignalCatcher::Signals::HeikinAshi do
  # Cause we have a really small difference with TV calculations - real tv results were redacted a little bit
  describe '#check!' do
    subject do
      described_class.new(
        klines: klines,
        signal_params: signal_params,
        strategy_hash: strategy_hash,
        indicator_keys: [indicator_key]
      ).check!
    end

    let(:ohlcv) { (1..5).map { rand } }
    let(:indicator_key) { 'heikin_ashi' }
    let(:strategy_hash) { SecureRandom.hex }
    let(:klines) do
      SignalCatcher::Entities::Kline.build(
        [[Time.now.to_i - 120, *ohlcv],
         [Time.now.to_i - 60, *ohlcv],
         [Time.now.to_i, *ohlcv]]
      )
    end

    let(:signal_params) do
      {
        'value' => 3,
        'condition' => condition
      }
    end

    context 'when condition is less' do
      let(:condition) { :less }

      context 'when condition met' do
        before do
          klines.each.with_index do |kline, index|
            kline.set_indicator_result(indicator_key, {ha_open: index, ha_close: index + 1})
          end
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition not met' do
        before do
          klines.each.with_index do |kline, index|
            kline.set_indicator_result(indicator_key, {ha_open: index + 1, ha_close: index})
          end
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end

      context 'when klines do not have indicator data' do
        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_nil
        end
      end
    end

    context 'when condition is greater' do
      let(:condition) { :greater }

      context 'when condition met' do
        before do
          klines.each.with_index do |kline, index|
            kline.set_indicator_result(indicator_key, {ha_open: index + 1, ha_close: index})
          end
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition not met' do
        before do
          klines.each.with_index do |kline, index|
            kline.set_indicator_result(indicator_key, {ha_open: index, ha_close: index + 1})
          end
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end
    end
  end
end
