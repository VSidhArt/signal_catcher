# frozen_string_literal: true

require 'support/shared_examples/comperative_signal'

RSpec.describe SignalCatcher::Signals::Adx do
  it_behaves_like 'comperative signal' do
    let(:condition_value) { 50 }
    let(:low_value) {  20 }
    let(:high_value) { 70 }
  end
end
