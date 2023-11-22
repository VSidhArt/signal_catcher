# frozen_string_literal: true

RSpec.describe SignalCatcher::Indicators::Cci do
  describe 'indicator results' do
    subject do
      described_class.new(
        klines: klines,
        indicator_params: indicator_params,
        indicator_key: key
      ).calculate!
    end

    let(:key) { 'cci_time_period_20' }
    let(:indicator_params) do
      {
        'time_period' => 20
      }
    end

    let(:skip_checks_values) { 19 }

    context 'with USDT_BTC pair' do
      let(:klines) { usdt_btc_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_btc_1d/cci.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key).round(3) }
        expect(result_values).to eq(indicator_tv_results[skip_checks_values..])
      end
    end

    context 'with USDT_PIT pair' do
      let(:klines) { usdt_pit_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_pit_1d/cci.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key).round(3) }
        expect(result_values).to eq(indicator_tv_results[skip_checks_values..])
      end
    end
  end
end
