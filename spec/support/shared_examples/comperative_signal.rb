# frozen_string_literal: true

RSpec.shared_examples 'comperative signal' do
  describe '#check!' do
    subject do
      described_class.new(
        klines: klines,
        signal_params: signal_params,
        strategy_hash: strategy_hash,
        indicator_keys: ['rsi']
      ).check!
    end

    let(:strategy_hash) { SecureRandom.hex }
    let(:ohlcv) { (1..5).map { rand } }

    let(:klines) { SignalCatcher::Entities::Kline.build([[Time.now.to_i - 60, *ohlcv], [Time.now.to_i, *ohlcv]]) }

    context 'when condition is less' do
      let(:signal_params) do
        {value: condition_value, condition: :less}
      end

      context 'when condition met' do
        before { klines.last.set_indicator_result('rsi', low_value) }

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition does not met' do
        before { klines.last.set_indicator_result('rsi', high_value) }

        it 'set signal result as flase' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end
    end

    context 'when condition is greater' do
      let(:signal_params) do
        {value: condition_value, condition: :greater}
      end

      context 'when condition met' do
        before do
          klines.last.set_indicator_result('rsi', high_value)
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition does not met' do
        before { klines.last.set_indicator_result('rsi', low_value) }

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end
    end

    context 'when condition is greater_or_equal' do
      let(:signal_params) do
        {value: condition_value, condition: :greater_or_equal}
      end

      context 'when condition met by greater' do
        before { klines.last.set_indicator_result('rsi', high_value) }

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition met by equal' do
        before { klines.last.set_indicator_result('rsi', condition_value) }

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition does not met' do
        before { klines.last.set_indicator_result('rsi', low_value) }

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end
    end

    context 'when condition is less_or_equal' do
      let(:signal_params) do
        {value: condition_value, condition: :less_or_equal}
      end

      context 'when condition met by greater' do
        before { klines.last.set_indicator_result('rsi', low_value) }

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition met by equal' do
        before { klines.last.set_indicator_result('rsi', condition_value) }

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition does not met' do
        before { klines.last.set_indicator_result('rsi', high_value) }

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end
    end

    context 'when condition is crossing_below' do
      let(:signal_params) do
        {value: condition_value, condition: :crossing_below}
      end

      context 'when condition met' do
        before do
          klines.first.set_indicator_result('rsi', low_value)
          klines.last.set_indicator_result('rsi', high_value)
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition does not met' do
        before do
          klines.first.set_indicator_result('rsi', high_value)
          klines.last.set_indicator_result('rsi', low_value)
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end
    end

    context 'when condition is crossing_above' do
      let(:signal_params) do
        {value: condition_value, condition: :crossing_above}
      end

      context 'when condition met' do
        before do
          klines.first.set_indicator_result('rsi', high_value)
          klines.last.set_indicator_result('rsi', low_value)
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition does not met' do
        before do
          klines.first.set_indicator_result('rsi', low_value)
          klines.last.set_indicator_result('rsi', high_value)
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end

      context 'when indicator results is nil' do
        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsey
        end
      end
    end
  end
end
