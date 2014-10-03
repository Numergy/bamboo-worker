# -*- coding: utf-8 -*-
require 'travis/yaml'

unless $LOAD_PATH.include?(File.expand_path('../', __FILE__))
  $LOAD_PATH.unshift(File.expand_path('../', __FILE__))
end

require 'bamboo-worker/version'
