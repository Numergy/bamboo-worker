# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/shell/node'

# Bamboo worker tests
module BambooWorker
  # shell tests
  module Shell
    describe 'Shell::Node' do
      it 'should initialize node' do
        node = Node.new('ls')
        expect(node.code).to eq('ls')
        expect(node.options).to eq({})
      end

      it 'should initialize with level in options' do
        node = Node.new('ls', level: 1)
        expect(node.code).to eq('ls')
        expect(node.options).to eq({})
        expect(node.level).to eq(1)
      end

      it 'should return code' do
        node = Node.new('ls')
        expect(node.to_s).to eq('ls')
      end

      it 'should return code with indent' do
        node = Node.new('ls', level: 1)
        expect(node.to_s).to eq('  ls')
      end

      it 'should escape code' do
        node = Node.new("cat special's.txt")
        expect(node.escape(node.code)).to eq('cat\\ special\\\'s.txt')
      end
    end
  end
end
