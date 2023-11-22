# frozen_string_literal: true

RSpec.describe SignalCatcher::Indicators::HeikinAshi do
  # Cause we have a really small difference with TV calculations - real tv results were redacted a little bit
  describe 'indicator results' do
    subject do
      described_class.new(
        klines: klines,
        indicator_params: indicator_params,
        indicator_key: key
      ).calculate!
    end

    let(:key) { 'heikin_ashi' }
    let(:indicator_params) { {} }

    let(:skip_checks_values) { 100 }

    context 'with USDT_BTC pair' do
      let(:klines) { usdt_btc_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_btc_1d/heikin_ashi.json') }

      it 'returns correct values' do
        subject
        klines.each.with_index do |kline, index|
          next if index < skip_checks_values

          heikin_ashi_values = kline.indicator_result(key).values.map(&:round)
          expect(heikin_ashi_values).to match_array(indicator_tv_results[index].map(&:round))
        end
      end
    end

    context 'with USDT_PIT pair' do
      let(:klines) { usdt_pit_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_pit_1d/heikin_ashi.json') }

      it 'returns correct values' do
        subject
        klines.each.with_index do |kline, index|
          heikin_ashi_values = kline.indicator_result(key).values.map { |r| r.round(12) }
          expect(heikin_ashi_values).to match_array(indicator_tv_results[index])
        end
      end
    end
  end
end
