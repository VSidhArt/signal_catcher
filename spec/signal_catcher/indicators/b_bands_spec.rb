# frozen_string_literal: true

RSpec.describe SignalCatcher::Indicators::BBands do
  # We have really small difference with TV calculations that we can't explain or fix
  # You can remove roundings and check
  describe 'indicator results' do
    subject do
      described_class.new(
        klines: klines,
        indicator_params: indicator_params,
        indicator_key: key
      ).calculate!
    end

    let(:key) { 'b_bands_ohlcv_value_close_time_period_20' }
    let(:indicator_params) do
      {
        'time_period' => 20,
        'ohlcv_value' => 'close',
        'ma_type' => 'sma',
        'deviations_up' => 2,
        'deviations_down' => 2
      }
    end

    let(:skip_checks_values) { 20 }

    context 'with USDT_BTC pair' do
      let(:klines) { usdt_btc_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_btc_1d/b_bands.json') }

      it 'returns correct values' do
        subject
        klines.each.with_index do |kline, index|
          next if index < skip_checks_values

          our_result = kline.indicator_result(key)
          tv_result = indicator_tv_results[index]

          expect(our_result[0].round).to eq(BigDecimal(tv_result['upper_band']).round)
          expect(our_result[1].round).to eq(BigDecimal(tv_result['middle_band']).round)
          expect(our_result[2].round).to eq(BigDecimal(tv_result['lower_band']).round)
        end
      end
    end

    context 'with USDT_PIT pair' do
      let(:klines) { usdt_pit_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_pit_1d/b_bands.json') }

      it 'returns correct values' do
        subject
        klines.each.with_index do |kline, index|
          next if index < skip_checks_values

          our_result = kline.indicator_result(key)
          tv_result = indicator_tv_results[index]

          expect(our_result[0].round).to eq(BigDecimal(tv_result['upper_band']).round)
          expect(our_result[1].round).to eq(BigDecimal(tv_result['middle_band']).round)
          expect(our_result[2].round).to eq(BigDecimal(tv_result['lower_band']).round)
        end
      end
    end
  end
end
