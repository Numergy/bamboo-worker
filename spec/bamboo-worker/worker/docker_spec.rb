# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/worker'
require 'bamboo-worker/worker/docker'

# Template tests
module BambooWorker
  describe 'Worker::Docker' do
    include FakeFS::SpecHelpers

    before(:each) do
      Dir.mkdir('/usr')
      Dir.mkdir('/usr/bin')
      File.open('/usr/bin/docker', 'w+') { |f| f.write(true) }
      File.chmod(0755, '/usr/bin/docker')
    end

    it 'should initialize docker binary' do
      expect(Worker::Docker.new.executable)
        .to eq('/usr/bin/docker')
    end

    it 'should run script' do
      docker = Worker::Docker.new
      docker.should_receive(:system)
        .with("/usr/bin/docker run -t -w '/tmp/build/test'" \
              " --entrypoint '/bin/bash' -v /tmp:/tmp/build " \
              "'127.0.0.1:5000/ruby-builder'" \
              " --login -c 'chmod +x /tmp/build/test.sh; /tmp/build/test.sh'")
        .and_return(true)

      Struct.new('TRAVIS_OK', :language)
      Struct.new('CHILD_STATUS_OK', :exitstatus)

      $CHILD_STATUS = Struct::CHILD_STATUS_OK.new(0)

      expect(docker.run('test',
                        Struct::TRAVIS_OK.new('ruby'),
                        '/tmp/test.sh',
                        { r: '127.0.0.1',
                          p: 5000 },
                        []))
        .to be_nil
    end

    it 'should raise error when exitstatus is not 0' do
      docker = Worker::Docker.new
      docker.should_receive(:system)
        .with("/usr/bin/docker run -t -w '/tmp/build/test'" \
              " --entrypoint '/bin/bash' -v /tmp:/tmp/build " \
              "'127.0.0.1:5000/ruby-builder'" \
              " --login -c 'chmod +x /tmp/build/test.sh; /tmp/build/test.sh'")
        .and_return(true)

      Struct.new('TRAVIS_NOT_OK', :language)
      Struct.new('CHILD_STATUS_NOT_OK', :exitstatus)

      $CHILD_STATUS = Struct::CHILD_STATUS_NOT_OK.new(1)

      expect do
        docker.run('test',
                   Struct::TRAVIS_NOT_OK.new('ruby'),
                   '/tmp/test.sh',
                   { r: '127.0.0.1',
                     p: 5000 },
                   [])
      end.to raise_error(SystemCallError)
    end
  end
end
