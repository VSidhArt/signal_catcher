# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

require 'indicator'
require 'oj'

module SignalCatcher
  class Error < StandardError; end
end
