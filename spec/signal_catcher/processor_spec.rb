# frozen_string_literal: true

RSpec.describe SignalCatcher::Processor do
  describe '#call' do
    subject { described_class.new(raw_klines, raw_strategies).call }

    let(:raw_klines) { Oj.load_file('spec/fixtures/usdt_btc_1d/klines.json') }

    context 'with rsi and 2 ma cross strategies' do
      let(:rsi_strategy) do
        {strategy_hash: SecureRandom.hex,
         indicator_type: 'rsi',
         signal_params: {
           trigger: {
             value: '44',
             condition: 'greater'
           }
         },
         indicator_params: {ohlcv_value: 'close', time_period: 14}}
      end

      let(:ma_cross_strategy_crossing_below) do
        {strategy_hash: SecureRandom.hex,
         indicator_type: 'ma_cross',
         signal_params: {trigger: {condition: 'crossing_below'}},
         indicator_params: {ma_type: 'sma', ohlcv_value: 'close', time_period_first: 9, time_period_second: 50}}
      end

      let(:ma_cross_strategy_crossing_above) do
        {strategy_hash: SecureRandom.hex,
         indicator_type: 'ma_cross',
         signal_params: {trigger: {condition: 'crossing_above'}},
         indicator_params: {ma_type: 'sma', ohlcv_value: 'close', time_period_first: 9, time_period_second: 50}}
      end

      let(:raw_strategies) do
        [rsi_strategy, ma_cross_strategy_crossing_below, ma_cross_strategy_crossing_above]
      end

      let(:rsi_skip_checks_values) { 152 }
      let(:expected_rsi_strategy_result) do
        Oj.load_file('spec/fixtures/usdt_btc_1d/rsi_strategy_results_greater_44.json')[rsi_skip_checks_values..]
      end

      let(:ma_cross_skip_checks_values) { 50 }

      let(:expected_ma_cross_below_result) do
        Oj.load_file('spec/fixtures/usdt_btc_1d/sma_9_50_crossing_below.json')[ma_cross_skip_checks_values..]
      end

      let(:expected_ma_cross_above_result) do
        Oj.load_file('spec/fixtures/usdt_btc_1d/sma_9_50_crossing_above.json')[ma_cross_skip_checks_values..]
      end

      it 'return valid reuslt' do
        expect(subject.size).to eq(raw_klines.size)
        expect(subject.first.open_time).to eq(raw_klines.first.first)
        expect(subject.last.open_time).to eq(raw_klines.last.first)

        rsi_strategy_result =
          subject[rsi_skip_checks_values..].map { |kline| kline.signal_result(rsi_strategy[:strategy_hash]) }

        ma_cross_strategy_crossing_below_result =
          subject[ma_cross_skip_checks_values..].map do |kline|
            kline.signal_result(ma_cross_strategy_crossing_below[:strategy_hash])
          end
        ma_cross_strategy_crossing_above_result =
          subject[ma_cross_skip_checks_values..].map do |kline|
            kline.signal_result(ma_cross_strategy_crossing_above[:strategy_hash])
          end

        expect(rsi_strategy_result).to eq(expected_rsi_strategy_result)
        expect(ma_cross_strategy_crossing_below_result).to eq(expected_ma_cross_below_result)
        expect(ma_cross_strategy_crossing_above_result).to eq(expected_ma_cross_above_result)
      end
    end
  end
end
