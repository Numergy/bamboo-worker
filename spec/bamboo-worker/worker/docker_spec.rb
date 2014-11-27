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
      docker.should_receive(:exec)
        .with('/usr/bin/docker run -t -i --entrypoint ' \
              "'/bin/bash' -v /tmp:/tmp/build  --login -c" \
              " 'cd /tmp/build'; ./tmp/test.sh")
        .and_return(true)

      expect(docker.run('/tmp/test.sh', []))
        .to eq(true)
    end
  end
end
