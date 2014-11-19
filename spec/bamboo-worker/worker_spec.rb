# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/worker'

# Template tests
module BambooWorker
  describe 'Worker::Abstract' do
    include FakeFS::SpecHelpers
    it 'should raise exception when worker\'s executable not found' do
      expect { Worker::Abstract.new '/fake/executable' }
        .to raise_error(RuntimeError,
                        'Can\'t find executable /fake/executable')
    end
  end
end
