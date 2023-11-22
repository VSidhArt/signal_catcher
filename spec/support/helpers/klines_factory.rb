# frozen_string_literal: true

module Helpers
  module KlinesFactory
    def usdt_btc_1d_klines
      SignalCatcher::Entities::Kline.build(Oj.load_file('spec/fixtures/usdt_btc_1d/klines.json'))
    end

    def usdt_pit_1d_klines
      SignalCatcher::Entities::Kline.build(Oj.load_file('spec/fixtures/usdt_pit_1d/klines.json'))
    end
  end
end
