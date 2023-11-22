# frozen_string_literal: true

RSpec.describe SignalCatcher::Signals::ParabolicSar do
  describe '#check!' do
    subject do
      described_class.new(
        klines: klines,
        signal_params: signal_params,
        strategy_hash: strategy_hash,
        indicator_keys: [indicator_key]
      ).check!
    end

    let(:indicator_key) { 'sar' }
    let(:strategy_hash) { SecureRandom.hex }

    let(:signal_params) do
      {
        condition: condition
      }
    end

    context 'when condition is crossing_below' do
      let(:condition) { :crossing_below }
      let(:klines) do
        SignalCatcher::Entities::Kline.build(
          [
            [Time.now.to_i - 60, 0, 0, 0, 100, 0],
            [Time.now.to_i - 60, 0, 0, 0, 150, 0]
          ]
        )
      end

      context 'when condition met' do
        before do
          klines.first.set_indicator_result(indicator_key, 120)
          klines.last.set_indicator_result(indicator_key, 110)
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition not met' do
        before do
          klines.first.set_indicator_result(indicator_key, 120)
          klines.last.set_indicator_result(indicator_key, 160)
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end
    end

    context 'when condition is crossing_above' do
      let(:condition) { :crossing_above }
      let(:klines) do
        SignalCatcher::Entities::Kline.build(
          [
            [Time.now.to_i - 60, 0, 0, 0, 150, 0],
            [Time.now.to_i - 60, 0, 0, 0, 100, 0]
          ]
        )
      end

      context 'when condition met' do
        before do
          klines.first.set_indicator_result(indicator_key, 130)
          klines.last.set_indicator_result(indicator_key, 110)
        end

        it 'set signal result as true' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_truthy
        end
      end

      context 'when condition not met' do
        before do
          klines.first.set_indicator_result(indicator_key, 110)
          klines.last.set_indicator_result(indicator_key, 90)
        end

        it 'set signal result as false' do
          subject
          expect(klines.last.signal_result(strategy_hash)).to be_falsy
        end
      end
    end
  end
end
