# frozen_string_literal: true

RSpec.describe SignalCatcher::Indicators::Sma do
  describe 'indicator results' do
    subject do
      described_class.new(
        klines: klines,
        indicator_params: indicator_params,
        indicator_key: key
      ).calculate!
    end

    let(:key) { 'sma_time_period_9' }
    let(:skip_checks_values) { 9 }
    let(:indicator_params) do
      {
        'time_period' => 9
      }
    end

    context 'with USDT_BTC pair' do
      let(:klines) { usdt_btc_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_btc_1d/sma_9.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key).round(3) }
        expect(result_values).to eq(indicator_tv_results[skip_checks_values..])
      end
    end

    context 'with USDT_PIT pair' do
      let(:klines) { usdt_pit_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_pit_1d/sma.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key).round(12) }
        expect(result_values).to eq(indicator_tv_results[skip_checks_values..])
      end
    end
  end
end
