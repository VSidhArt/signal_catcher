# frozen_string_literal: true

module SignalCatcher
  module Indicators
    module Shared
      module MaTypesMixin
        MAPPING =
          {
            sma: TaLib::TA_MAType_SMA,
            ema: TaLib::TA_MAType_EMA,
            wma: TaLib::TA_MAType_WMA,
            dema: TaLib::TA_MAType_DEMA,
            tema: TaLib::TA_MAType_TEMA,
            trima: TaLib::TA_MAType_TRIMA,
            kama: TaLib::TA_MAType_KAMA,
            mama: TaLib::TA_MAType_MAMA,
            t3: TaLib::TA_MAType_T3
          }.freeze

        # Maps moving average types to their corresponding TaLib constants.
        # @return [Hash] The map of moving average types to TaLib constants.
        def ma_types_map(ma_type)
          MAPPING[ma_type]
        end
      end
    end
  end
end
