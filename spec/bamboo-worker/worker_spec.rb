# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/worker'

# Worker tests
module BambooWorker
  describe 'Worker::Base' do
    include FakeFS::SpecHelpers
    it 'should raise exception when worker\'s executable not found' do
      expect { Worker::Base.new '/fake/executable' }
        .to raise_error(RuntimeError,
                        'Can\'t find executable /fake/executable, '\
                        'or is not executable.')
    end

    it 'should set worker\'s executable when it exists' do
      Dir.mkdir('/bin')
      File.open('/bin/worker', 'w+') { |f| f.write(true) }
      File.chmod(0755, '/bin/worker')
      expect(Worker::Base.new('/bin/worker').executable)
        .to eq('/bin/worker')
    end

    it 'should raise error if run method is called from abstract class' do
      Dir.mkdir('/bin')
      File.open('/bin/worker', 'w+') { |f| f.write(true) }
      File.chmod(0755, '/bin/worker')
      expect do
        Worker::Base.new('/bin/worker')
          .run('host', 'port', '', 'config', '', '')
      end.to raise_error(NotImplementedError)
    end
  end
end
