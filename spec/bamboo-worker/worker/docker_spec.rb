# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/worker'
require 'bamboo-worker/worker/docker'

# Docker worker tests
module BambooWorker
  describe 'Worker::Docker' do
    include FakeFS::SpecHelpers

    before(:each) do
      Dir.mkdir('/usr')
      Dir.mkdir('/usr/bin')
      File.open('/usr/bin/docker', 'w+') { |f| f.write(true) }
      File.chmod(0755, '/usr/bin/docker')
      @docker = Worker::Docker.new
      allow(BambooWorker::Logger).to receive(:error)
    end

    it 'should initialize docker binary' do
      expect(@docker.executable)
        .to eq('/usr/bin/docker')
    end

    it 'should return false if there is no information for docker in config' do
      expect(@docker.run('test',
                         {},
                         {},
                         '/tmp/test.sh',
                         {},
                         []))
        .to eq(false)
    end

    it 'should return false if container wasn\'t found' do
      config = {
        'docker' => {
          'azdoazdazd' => {
          }
        }
      }

      travis = Struct.new(:language)
      project_config = travis.new('ruby')
      allow(project_config).to receive(:key?).and_return(false)

      docker_run = @docker.run('test',
                               config,
                               project_config,
                               '/tmp/test.sh',
                               {},
                               [])
      expect(docker_run).to eq(false)
    end

    it 'should raise error when command failed' do
      allow(@docker).to receive(:system)
        .with('/usr/bin/docker run -t --rm' \
              ' -e LANG=en_US.UTF-8' \
              ' -e LANGUAGE=en_US.UTF-8' \
              ' -e LC_ALL=en_US.UTF-8' \
              " -h $(hostname) -w '/tmp/build'" \
              " --entrypoint '/bin/bash' -v test:/tmp/build " \
              '-v /tmp:/tmp/script ' \
              "'127.0.0.1:5000/ruby-builder'" \
              " --login -c 'chmod +x /tmp/script/test.sh; /tmp/script/test.sh'")
        .and_return(true)

      $CHILD_STATUS = double
      allow($CHILD_STATUS).to receive(:success?).and_return(false)
      config = {
        'docker' => {
          'containers' => {
            'ruby' => '127.0.0.1:5000/ruby-builder'
          }
        }
      }

      travis = Struct.new(:language)
      project_config = travis.new('ruby')
      allow(project_config).to receive(:key?).and_return(false)

      expect do
        @docker.run('test',
                    config,
                    project_config,
                    '/tmp/test.sh',
                    {},
                    [])
      end.to raise_error(SystemCallError)
    end

    it 'should run script' do
      allow(@docker).to receive(:system)
        .with('/usr/bin/docker run -t --rm' \
              ' -e LANG=en_US.UTF-8' \
              ' -e LANGUAGE=en_US.UTF-8' \
              ' -e LC_ALL=en_US.UTF-8' \
              " -h $(hostname) -w '/tmp/build'" \
              " --entrypoint '/bin/bash' -v test:/tmp/build " \
              '-v /tmp:/tmp/script ' \
              "'127.0.0.1:5000/ruby-builder'" \
              " --login -c 'chmod +x /tmp/script/test.sh; /tmp/script/test.sh'")
        .and_return(true)

      $CHILD_STATUS = double
      allow($CHILD_STATUS).to receive(:success?).and_return(true)

      config = {
        'docker' => {
          'containers' => {
            'ruby' => '127.0.0.1:5000/ruby-builder'
          }
        }
      }

      travis = Struct.new(:language)
      project_config = travis.new('ruby')
      allow(project_config).to receive(:key?).and_return(false)
      expect(@docker.run('test',
                         config,
                         project_config,
                         '/tmp/test.sh',
                         { r: '127.0.0.1',
                           p: 5000 },
                         []))
        .to eq(true)
    end

    it 'should run script with custom container' do
      allow(@docker).to receive(:system)
        .with('/usr/bin/docker run -t --rm' \
              ' -e LANG=en_US.UTF-8' \
              ' -e LANGUAGE=en_US.UTF-8' \
              ' -e LC_ALL=en_US.UTF-8' \
              " -h $(hostname) -w '/tmp/build'" \
              " --entrypoint '/bin/bash' -v test:/tmp/build " \
              '-v /tmp:/tmp/script ' \
              "'10.0.0.1:5000/my-container'" \
              " --login -c 'chmod +x /tmp/script/test.sh; /tmp/script/test.sh'")
        .and_return(true)

      $CHILD_STATUS = double
      allow($CHILD_STATUS).to receive(:success?).and_return(true)

      config = {}
      travis = Struct.new(:language, :docker)
      project_config = travis.new('ruby',
                                  'container' => '10.0.0.1:5000/my-container')
      allow(project_config).to receive(:key?).with('docker').and_return(true)

      expect(@docker.run('test',
                         config,
                         project_config,
                         '/tmp/test.sh',
                         { r: '127.0.0.1',
                           p: 5000 },
                         []))
        .to eq(true)
    end
  end
end
