# frozen_string_literal: true

require 'support/shared_examples/comperative_signal'

RSpec.describe SignalCatcher::Signals::BBandsPercent do
  it_behaves_like 'comperative signal' do
    let(:condition_value) { 1 }
    let(:low_value) { -1.5 }
    let(:high_value) { 1.5 }
  end
end
