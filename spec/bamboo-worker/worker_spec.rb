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
                        'Can\'t find executable /fake/executable, '\
                        'or is not executable.')
    end

    it 'should set worker\'s executable when it exists' do
      Dir.mkdir('/bin')
      File.open('/bin/worker', 'w+') { |f| f.write(true) }
      File.chmod(0755, '/bin/worker')
      expect(Worker::Abstract.new('/bin/worker').executable)
        .to eq('/bin/worker')
    end
  end
end
