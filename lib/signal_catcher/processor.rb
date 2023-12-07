# frozen_string_literal: true

module SignalCatcher
  class Processor
    # Build internal entities(strategies and klines), run calculations and return results
    attr_reader :klines, :strategies

    # @param raw_klines [Array<Array<Float>>] klines in OHLCV format
    # @param raw_strategies [Arrat<Hash>] strategies in Kekko format
    def initialize(raw_klines, raw_strategies)
      @klines = SignalCatcher::Entities::Kline.build(raw_klines)
      @strategies = SignalCatcher::Entities::Strategy.build(raw_strategies)
    end

    # @return [Array<SignalCatcher::Entities::Kline>] klines with indicators and signals results
    def call
      strategies
        .each { |strategy| strategy.calculate_indicators!(klines) }
        .each { |strategy| strategy.check_signals!(klines) }

      klines
    end
  end
end
