# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SignalCatcher::Indicators::Shared::MaTypesMixin do
  include described_class

  describe '#find_ma_klass' do
    it 'returns the correct TaLib constant for SMA' do
      expect(find_ma_klass(:sma)).to eq(TaLib::TA_MAType_SMA)
    end

    it 'returns the correct TaLib constant for EMA' do
      expect(find_ma_klass(:ema)).to eq(TaLib::TA_MAType_EMA)
    end

    it 'returns the correct TaLib constant for WMA' do
      expect(find_ma_klass(:wma)).to eq(TaLib::TA_MAType_WMA)
    end

    it 'returns the default TaLib constant for an unknown MA type' do
      expect(find_ma_klass(:unknown)).to eq(TaLib::TA_MAType_SMA)
    end
  end
end
