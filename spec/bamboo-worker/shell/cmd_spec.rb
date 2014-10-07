# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/shell/node'
require 'bamboo-worker/shell/cmd'

# Bamboo worker tests
module BambooWorker
  # shell tests
  module Shell
    describe 'Shell::Cmd' do
      it 'should initialize cmd' do
        node = Cmd.new('ls')
        expect(node.code).to eq('ls')
        expect(node.options).to eq({})
      end

      it 'should initialize with options' do
        node = Cmd.new('ls', level: 1, retry: true)
        expect(node.code).to eq('bamboo_cmd ls --retry')
        expect(node.options).to eq(retry: true)
        expect(node.level).to eq(1)
      end

      it 'should return opts' do
        node = Cmd.new('ls', assert: true)
        expect(node.opts).to eq(['--assert'])
        node = Cmd.new('ls', echo: true)
        expect(node.opts).to eq(['--echo'])
        node = Cmd.new('ls', retry: true)
        expect(node.opts).to eq(['--retry'])
        node = Cmd.new('ls', timing: true)
        expect(node.opts).to eq(['--timing'])
        node = Cmd.new('ls', retry: true, timing: true)
        expect(node.opts).to eq(['--retry', '--timing'])
      end
    end
  end
end
