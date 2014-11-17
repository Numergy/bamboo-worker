# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/shell/dsl'
# Bamboo worker tests
module BambooWorker
  # shell tests
  module Shell
    describe 'Shell::Dsl' do
      before(:each) do
        @dsl = DummyClass.new
      end

      it 'should raw new line' do
        @dsl.newline
        expect(@dsl.nodes.first.code).to eq('echo')
        expect(@dsl.nodes.first.options).to eq({})
      end

      it 'should export' do
        @dsl.export('USER', 'got')
        expect(@dsl.nodes.first.code).to eq('export USER=got')
        expect(@dsl.nodes.first.options).to eq(assert: false)
      end

      it 'should export with options' do
        @dsl.export('USER', 'got', assert: true)
        expect(@dsl.nodes.first.code)
          .to eq('bamboo_cmd export\\ USER\\=got --assert')
        expect(@dsl.nodes.first.options).to eq(assert: true)
      end

      it 'should execute command' do
        @dsl.cmd('rbenv --version')
        expect(@dsl.nodes.first.to_s).to eq('rbenv --version')
        expect(@dsl.nodes.first).to be_a(::BambooWorker::Shell::Cmd)
      end

      it 'should prepare if statement' do
        @dsl.if('-f test', 'cat test')
        expect(@dsl.nodes.map(&:to_s)).to eq(['if [[ -f test ]]; ' \
                                              "then\n  cat test\nfi"])
      end

      it 'should prepare if else statements with if method' do
        @dsl.if('-f test', 'cat test', else: 'ls test')
        expect(@dsl.nodes.map(&:to_s))
          .to eq(["if [[ -f test ]]; then\n  cat test\nelse\n  ls test\nfi"])
      end

      it 'should prepare if else statements with if and else methods' do
        @dsl.if('-f test', 'cat test')
        @dsl.else('ls test')
        expect(@dsl.nodes.map(&:to_s))
          .to eq(["if [[ -f test ]]; then\n  cat test\nelse\n  ls test\nfi"])
      end

      it 'should prepare if elif statements with if and elif methods' do
        @dsl.if('-f test', 'cat test')
        @dsl.elif('-f truc', 'ls truc')
        expect(@dsl.nodes.map(&:to_s))
          .to eq(["if [[ -f test ]]; then\n  cat test" \
                  "\nelif [[ -f truc ]]; then\n  ls truc\nfi"])
      end

      it 'should prepare if/elif/else statements with if and elif methods' do
        @dsl.if('-f test', 'cat test')
        @dsl.elif('-f truc', 'ls truc', else: 'cat something')
        expect(@dsl.nodes.map(&:to_s))
          .to eq(["if [[ -f test ]]; then\n  cat test" \
                  "\nelif [[ -f truc ]]; then\n  ls truc\n" \
                  "else\n  cat something\nfi"])
      end

      it 'should prepare if/elif/else statements with if/elif/else methods' do
        @dsl.if('-f test', 'cat test')
        @dsl.elif('-f truc', 'ls truc')
        @dsl.else('cat something')
        expect(@dsl.nodes.map(&:to_s))
          .to eq(["if [[ -f test ]]; then\n  cat test" \
                  "\nelif [[ -f truc ]]; then\n  ls truc\n" \
                  "else\n  cat something\nfi"])
      end

      it 'should echo new line' do
        @dsl.echo('')
        expect(@dsl.nodes.map(&:to_s))
          .to eq(['echo'])
      end

      it 'should echo something' do
        @dsl.echo('my message')
        expect(@dsl.nodes.map(&:to_s))
          .to eq(["echo 'my message'"])
      end

      it 'should echo something with escaping quotes' do
        @dsl.echo("my 'message'")
        expect(@dsl.nodes.map(&:to_s))
          .to eq(["echo 'my \\''message\\'''"])
      end

      it 'should failure with message' do
        @dsl.failure('error')
        expect(@dsl.nodes.map(&:to_s))
          .to eq(['export BAMBOO_CMD=no_script',
                  "echo 'error'",
                  'exit 1'])
      end
    end
  end
end

# Dummy class for test module
class DummyClass
  attr_reader :nodes
  include ::BambooWorker::Shell::Dsl

  def initialize
    @nodes = []
  end
end
