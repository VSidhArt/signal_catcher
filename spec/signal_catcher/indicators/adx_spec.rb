# frozen_string_literal: true

RSpec.describe SignalCatcher::Indicators::Adx do
  describe 'indicator results' do
    subject do
      described_class.new(
        klines: klines,
        indicator_params: indicator_params,
        indicator_key: key
      ).calculate!
    end

    let(:key) { 'adx_ohlcv_value_close_time_period_150' }
    let(:indicator_params) do
      {
        'time_period' => 14,
        'ohlcv_value' => 'close'
      }
    end

    let(:skip_checks_values) { 200 }

    context 'with USDT_BTC pair' do
      let(:klines) { usdt_btc_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_btc_1d/adx.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key).round(3) }
        expect(result_values).to eq(indicator_tv_results[skip_checks_values..])
      end
    end

    # Problem: depend on multiplier we have different indicator result, without multiplier we have all 0,
    # Now no exchange is able to count ADX for small prices, we have nothing to compare with
    context 'with USDT_PIT pair', :skip do
      let(:klines) { usdt_pit_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_pit_1d/adx.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key).round(3) }
        expect(result_values).to match_array(indicator_tv_results[skip_checks_values..])
      end
    end
  end
end
