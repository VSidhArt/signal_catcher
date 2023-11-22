# frozen_string_literal: true

RSpec.describe SignalCatcher::Indicators::Ema do
  describe 'indicator results' do
    subject do
      described_class.new(
        klines: klines,
        indicator_params: indicator_params,
        indicator_key: key
      ).calculate!
    end

    let(:key) { 'sma_time_period_20' }
    let(:indicator_params) do
      {
        'time_period' => 20
      }
    end

    let(:skip_checks_values) { 160 }

    context 'with USDT_BTC pair' do
      let(:klines) { usdt_btc_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_btc_1d/ema.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key).round(3) }
        expect(result_values).to eq(indicator_tv_results[skip_checks_values..])
      end
    end

    context 'with USDT_PIT pair' do
      let(:klines) { usdt_pit_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_pit_1d/ema.json') }

      let(:permissible_measurement_error) { 0.0000000000000001 }

      it 'returns correct values' do
        subject

        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key) }
        indicator_values = indicator_tv_results[skip_checks_values..]

        result_values.each.with_index do |result_value, index|
          expect(result_value).to be_within(permissible_measurement_error).of(indicator_values[index])
        end
      end
    end
  end
end
