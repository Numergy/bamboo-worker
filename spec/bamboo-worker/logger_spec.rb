# -*- coding: utf-8 -*-
require 'spec_helper'
require 'erubis'
require 'bamboo-worker/logger'

# Template tests
module BambooWorker
  describe 'Logger' do
    it 'should configure logger' do
      logger = Logger.logger
      expect(logger).to be_a(::Logger)
      expect(logger.level).to eq(::Logger::INFO)
      Logger.level('unknown')
      expect(logger.level).to eq(::Logger::UNKNOWN)
    end

    %w(debug error info fatal warn unknown).each do |type|
      it "should test #{type} message" do
        expect(Logger.send(type.to_sym, 'message')).to be_truthy
      end
    end
  end
end
