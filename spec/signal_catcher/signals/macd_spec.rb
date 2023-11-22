# frozen_string_literal: true

RSpec.describe SignalCatcher::Signals::Macd do
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
    let(:indicator_key) { 'macd' }
    let(:strategy_hash) { SecureRandom.hex }
    let(:klines) do
      SignalCatcher::Entities::Kline.build(
        [[Time.now.to_i - 60, *ohlcv],
         [Time.now.to_i, *ohlcv]]
      )
    end

    let(:signal_params) do
      {
        condition: condition,
        line_condition: line_condition,
        value: 0
      }
    end

    context 'when condition is crossing_below and line condition met' do
      let(:condition) { :crossing_below }
      let(:line_condition) { :greater }

      context 'when condition met' do
        before do
          klines.first.set_indicator_result(indicator_key, [1, 2])
          klines.last.set_indicator_result(indicator_key, [2, 1])
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition not met' do
        before do
          klines.first.set_indicator_result(indicator_key, [2, 1])
          klines.last.set_indicator_result(indicator_key, [3, 1])
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end
    end

    context 'when condition is crossing_above line condition met' do
      let(:condition) { :crossing_above }
      let(:line_condition) { :greater }

      context 'when condition met' do
        before do
          klines.first.set_indicator_result(indicator_key, [2, 1])
          klines.last.set_indicator_result(indicator_key, [1, 2])
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition not met' do
        before do
          klines.first.set_indicator_result(indicator_key, [1, 2])
          klines.last.set_indicator_result(indicator_key, [2, 1])
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end
    end

    context 'when line_condition is greater and condition met' do
      let(:condition) { :crossing_below }
      let(:line_condition) { :less }

      context 'when condition not met' do
        before do
          klines.first.set_indicator_result(indicator_key, [5, 10])
          klines.last.set_indicator_result(indicator_key, [12, 11])
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end

      context 'when condition met' do
        before do
          klines.first.set_indicator_result(indicator_key, [-10, -5])
          klines.last.set_indicator_result(indicator_key, [-2, -4])
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end
    end
  end
end
