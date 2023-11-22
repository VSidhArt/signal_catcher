# frozen_string_literal: true

require 'support/shared_examples/comperative_signal'

RSpec.describe SignalCatcher::Signals::Rsi do
  it_behaves_like 'comperative signal' do
    let(:condition_value) { 50 }
    let(:low_value) {  40 }
    let(:high_value) { 60 }
  end
end
