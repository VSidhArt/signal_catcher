# frozen_string_literal: true

RSpec.describe SignalCatcher::Signals::MaCross do
  describe '#check!' do
    subject do
      described_class.new(
        klines: klines,
        signal_params: signal_params,
        strategy_hash: strategy_hash,
        indicator_keys: %w[sma_9 sma_50]
      ).check!
    end

    let(:ohlcv) { (1..5).map { rand } }
    let(:strategy_hash) { SecureRandom.hex }
    let(:klines) do
      SignalCatcher::Entities::Kline.build(
        [[Time.now.to_i - 60, *ohlcv],
         [Time.now.to_i, *ohlcv]]
      )
    end

    let(:signal_params) do
      {
        condition: condition
      }
    end

    context 'when condition crossing below' do
      let(:condition) { :crossing_below }

      context 'when the condition meet' do
        before do
          klines.first.set_indicator_result('sma_9', 10)
          klines.last.set_indicator_result('sma_9', 20)

          klines.first.set_indicator_result('sma_50', 11)
          klines.last.set_indicator_result('sma_50', 19)
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when the condition does not meet' do
        before do
          klines.first.set_indicator_result('sma_9', 10)
          klines.last.set_indicator_result('sma_9', 20)

          klines.first.set_indicator_result('sma_50', 11)
          klines.last.set_indicator_result('sma_50', 22)
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end
    end

    context 'when condition crossing above' do
      let(:condition) { :crossing_above }

      context 'when the condition meet' do
        before do
          klines.first.set_indicator_result('sma_9', 20)
          klines.last.set_indicator_result('sma_9', 9)

          klines.first.set_indicator_result('sma_50', 11)
          klines.last.set_indicator_result('sma_50', 10)
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when the condition does not meet' do
        before do
          klines.first.set_indicator_result('sma_9', 20)
          klines.last.set_indicator_result('sma_9', 9)

          klines.first.set_indicator_result('sma_50', 11)
          klines.last.set_indicator_result('sma_50', 8)
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end
    end
  end
end
