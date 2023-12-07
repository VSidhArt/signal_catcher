# frozen_string_literal: true

module SignalCatcher
  module Indicators
    module Shared
      module MaTypesMixin
        # Maps moving average types to their corresponding TaLib constants.
        # @return [Hash] The map of moving average types to TaLib constants.
        def find_ma_klass(ma_type)
          Object.const_get("TaLib::TA_MAType_#{ma_type.upcase}")
        rescue NameError
          TaLib::TA_MAType_SMA
        end
      end
    end
  end
end
