# frozen_string_literal: true

module SignalCatcher
  module Indicators
    module Shared
      module PrepareIndicatorDataInRealMixin
        private

        def prepare_input
          @indicator.in_real(0, prepare_klines_data_in_real)
        end

        # Prepares the kline data in real number format.
        def prepare_klines_data_in_real
          klines.map { |kline| kline.public_send(ohlcv_value) * multiplier }
        end
      end
    end
  end
end
