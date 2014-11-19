# -*- coding: utf-8 -*-
require 'erubis'
require 'slop'
require 'travis/yaml'
require 'pathname'

unless $LOAD_PATH.include?(File.expand_path('../', __FILE__))
  $LOAD_PATH.unshift(File.expand_path('../', __FILE__))
end

require 'bamboo-worker/cli'
require 'bamboo-worker/cli/build'
require 'bamboo-worker/cli/run'
require 'bamboo-worker/script'
require 'bamboo-worker/shell'
require 'bamboo-worker/script/default'
require 'bamboo-worker/stages'
require 'bamboo-worker/template'
require 'bamboo-worker/version'
require 'bamboo-worker/worker'
require 'bamboo-worker/worker/docker'
