# frozen_string_literal: true

# Autoload all application classes
Dir[File.join(__dir__, '..', 'app', '**', '*.rb')].each { |file| require file }
