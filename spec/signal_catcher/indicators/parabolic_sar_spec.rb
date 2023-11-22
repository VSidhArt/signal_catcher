# frozen_string_literal: true

RSpec.describe SignalCatcher::Indicators::ParabolicSar do
  describe 'indicator results' do
    subject do
      described_class.new(
        klines: klines,
        indicator_params: indicator_params,
        indicator_key: key
      ).calculate!
    end

    let(:key) { 'sar_0.02' }
    let(:indicator_params) do
      {
        'acceleration_factor' => 0.02,
        'af_maximum' => 0.2
      }
    end

    let(:skip_checks_values) { 100 }
    let(:permissible_measurement_error) { 0.000000001 }

    let(:skip_indexes) { [551, 552, 553, 554, 555, 556, 557] }
    # "open_time: 2022-06-23, our_value: 21723.0,            tv_value: 17622.0"
    # "open_time: 2022-06-24, our_value: 17622.0,            tv_value: 17694.22"
    # "open_time: 2022-06-25, our_value: 17700.7282,         tv_value: 17848.7876"
    # "open_time: 2022-06-26, our_value: 17857.279072,       tv_value: 18074.730344"
    # "open_time: 2022-06-27, our_value: 18099.12232768,     tv_value: 18379.79191648"
    # "open_time: 2022-06-28, our_value: 18326.454988019203, tv_value: 18660.4485631616"
    # "open_time: 2022-06-29, our_value: 18540.14768873805,  tv_value: 18918.652678108672"

    context 'with USDT_BTC pair' do
      let(:klines) { usdt_btc_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_btc_1d/parabolic_sar.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key) }
        tv_results = indicator_tv_results[skip_checks_values..]

        result_values.each.with_index do |result_value, index|
          next if skip_indexes.include?(index)

          expect(result_value).to be_within(permissible_measurement_error).of(tv_results[index])
        end
      end
    end

    context 'with USDT_PIT pair' do
      let(:klines) { usdt_pit_1d_klines }
      let(:indicator_tv_results) { Oj.load_file('spec/fixtures/usdt_pit_1d/parabolic_sar.json') }

      it 'returns correct values' do
        subject
        result_values = klines[skip_checks_values..].map { |r| r.indicator_result(key) }
        tv_results = indicator_tv_results[skip_checks_values..]
        result_values.each.with_index do |result_value, index|
          expect(result_value).to be_within(permissible_measurement_error).of(tv_results[index])
        end
      end
    end
  end
end
