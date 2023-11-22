# frozen_string_literal: true

RSpec.describe SignalCatcher::Signals::Stochastic do
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
        value: 30
      }
    end

    context 'when line condition is crossing_below and condition met' do
      let(:line_condition) { :crossing_below }
      let(:condition) { :greater }

      context 'when condition met' do
        before do
          klines.first.set_indicator_result(indicator_key, [35, 37])
          klines.last.set_indicator_result(indicator_key, [40, 38])
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition not met' do
        before do
          klines.first.set_indicator_result(indicator_key, [35, 37])
          klines.last.set_indicator_result(indicator_key, [40, 41])
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end
    end

    context 'when line_condition is crossing_above condition met' do
      let(:line_condition) { :crossing_above }
      let(:condition) { :greater }

      context 'when condition met' do
        before do
          klines.first.set_indicator_result(indicator_key, [45, 42])
          klines.last.set_indicator_result(indicator_key, [40, 41])
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition not met' do
        before do
          klines.first.set_indicator_result(indicator_key, [45, 42])
          klines.last.set_indicator_result(indicator_key, [40, 39])
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end
    end

    context 'when condition is less and line_condition met' do
      let(:condition) { :less }
      let(:line_condition) { :crossing_above }

      context 'when condition not met' do
        before do
          klines.first.set_indicator_result(indicator_key, [44, 42])
          klines.last.set_indicator_result(indicator_key, [31, 39])
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end

      context 'when condition met' do
        before do
          klines.first.set_indicator_result(indicator_key, [44, 42])
          klines.last.set_indicator_result(indicator_key, [29, 39])
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end
    end
  end
end
