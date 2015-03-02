# -*- coding: utf-8 -*-
$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'simplecov'
require 'logger'
require 'fakefs/spec_helpers'

SimpleCov.start do
  add_filter '/spec/'
end
