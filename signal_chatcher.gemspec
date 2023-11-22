# frozen_string_literal: true

require_relative 'lib/signal_catcher/version'

Gem::Specification.new do |spec|
  spec.name          = 'signal_catcher'
  spec.version       = SignalCatcher::VERSION
  spec.authors       = ['Vadim Kershukov']
  spec.email         = ['vadim.kershukov@gmail.com']

  spec.summary       = 'Find trading signals'
  spec.description = <<~DESC
    Indicators and signals using wrapper around the talib-ruby library
    which is a ruby wrapper for the ta-lib library.
  DESC

  spec.homepage      = 'https://github.com/VSidhArt/signal_catcher'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.2')

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/VSidhArt/signal_catcher'
  spec.metadata['changelog_uri'] = 'https://github.com/VSidhArt/signal_catcher/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  # RUNTIME DEPENDENCIES
  spec.add_runtime_dependency('oj', '> 3.9.0')
  spec.add_runtime_dependency('ta-indicator')
  spec.add_runtime_dependency('zeitwerk', '~> 2.5.1')

  # DEVELOPMENT DEPENDENCIES
  spec.add_development_dependency('rspec', '~> 3.10.0')
  spec.add_development_dependency('rubocop', '~> 1.37.1')
  spec.add_development_dependency('rubocop-rspec', '~> 2.5.0')
end
