# -*- coding: utf-8 -*-
$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'simplecov'
require 'logger'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = :should
  end
end

SimpleCov.start do
  add_filter '/spec/'
end
