# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/cli'
require 'slop'

# Bamboo worker tests
module BambooWorker
  # CLI tests
  module CLI
    describe 'CLI' do
      it 'should return options' do
        options = CLI.options
        expect(options).to be_a(::Slop)
        expect(options.config[:strict]).to be_truthy
        expect(options.config[:banner])
          .to eq('Usage: bamboo-worker [COMMAND] [OPTIONS]')
        expect(options.to_s)
          .to match(/-v, --version(\s+)Shows the current version/)
        expect(options.to_s)
          .to match(/-h, --help(\s+)Display this help message./)

        version = options.fetch_option(:v)
        expect(version.short).to eq('v')
        expect(version.long).to eq('version')
        expect { version.call }.to output(/bamboo-worker v.* on ruby/).to_stdout
      end

      it 'should retrieve version information' do
        expect(CLI.version_information).to eq(
          "bamboo-worker v#{VERSION} on #{RUBY_DESCRIPTION}"
        )
      end
    end
  end
end
