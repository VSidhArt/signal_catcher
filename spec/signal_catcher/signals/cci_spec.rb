# frozen_string_literal: true

require 'support/shared_examples/comperative_signal'

RSpec.describe SignalCatcher::Signals::Cci do
  it_behaves_like 'comperative signal' do
    let(:condition_value) { 0 }
    let(:low_value) {  -100 }
    let(:high_value) { 100 }
  end
end
