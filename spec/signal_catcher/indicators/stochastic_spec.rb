# frozen_string_literal: true

RSpec.describe SignalCatcher::Indicators::Stochastic do
  describe 'indicator results' do
    subject do
      described_class.new(
        klines: klines,
        indicator_params: indicator_params,
        indicator_key: key
      ).calculate!
    end

    let(:key) { 'macd_ohlcv_value_close_time_period_20' }
    let(:skip_checks_values) { 200 }
    let(:permissible_measurement_error) { 0.000000000001 }

    let(:indicator_params) do
      {
        'slow_k_period' => 1,
        'fast_k_period' => 14,
        'slow_d_period' => 3
      }
    end

    context 'with USDT_BTC pair' do
      let(:klines) { usdt_btc_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_btc_1d/stoch.json') }

      it 'returns correct values' do
        subject

        klines.each.with_index do |kline, index|
          next if index < skip_checks_values

          our_result = kline.indicator_result(key)
          tv_result = indicator_tv_results[index]

          expect(our_result[0]).to be_within(permissible_measurement_error).of(tv_result['out_slow_k'])
          expect(our_result[1]).to be_within(permissible_measurement_error).of(tv_result['out_slow_d'])
        end
      end
    end

    context 'with USDT_PIT pair' do
      let(:klines) { usdt_pit_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_pit_1d/stoch.json') }

      it 'returns correct values' do
        subject

        klines.each.with_index do |kline, index|
          next if index < skip_checks_values

          our_result = kline.indicator_result(key)
          tv_result = indicator_tv_results[index]

          expect(our_result[0]).to be_within(permissible_measurement_error).of(tv_result['out_slow_k'])
          expect(our_result[1]).to be_within(permissible_measurement_error).of(tv_result['out_slow_d'])
        end
      end
    end
  end
end
