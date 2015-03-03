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
      @docker = Worker::Docker.new
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
      Struct.new('TRAVIS_ERROR', :language)
      config = {
        'docker' => {
          'azdoazdazd' => {
          }
        }
      }

      expect(@docker.run('test',
                         config,
                         Struct::TRAVIS_ERROR.new('ruby'),
                         '/tmp/test.sh',
                         {},
                         [])
             ).to eq(false)
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

      Struct.new('TRAVIS_NOT_OK', :language)

      $CHILD_STATUS = double
      allow($CHILD_STATUS).to receive(:success?).and_return(false)
      config = {
        'docker' => {
          'containers' => {
            'ruby' => '127.0.0.1:5000/ruby-builder'
          }
        }
      }

      expect do
        @docker.run('test',
                    config,
                    Struct::TRAVIS_NOT_OK.new('ruby'),
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

      Struct.new('TRAVIS_OK', :language)

      $CHILD_STATUS = double
      allow($CHILD_STATUS).to receive(:success?).and_return(true)

      config = {
        'docker' => {
          'containers' => {
            'ruby' => '127.0.0.1:5000/ruby-builder'
          }
        }
      }

      expect(@docker.run('test',
                         config,
                         Struct::TRAVIS_OK.new('ruby'),
                         '/tmp/test.sh',
                         { r: '127.0.0.1',
                           p: 5000 },
                         []))
        .to eq(true)
    end
  end
end
