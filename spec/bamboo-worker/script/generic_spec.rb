# -*- coding: utf-8 -*-
require 'spec_helper'
require 'travis/yaml'
require 'bamboo-worker/logger'
require 'bamboo-worker/shell'
require 'bamboo-worker/script/default'
require 'bamboo-worker/script/generic'

# Bamboo worker tests
module BambooWorker
  # generic script tests
  describe 'Script::Generic' do
    before(:each) do
      travis = Travis::Yaml.matrix('language: generic')
      @generic = Script::Generic.new(travis.first)
    end

    it 'should announce' do
      @generic.announce
      expect(@generic.nodes.map(&:to_s))
        .to eq(['bamboo_cmd bash\\ --version --echo'])
    end
  end
end
