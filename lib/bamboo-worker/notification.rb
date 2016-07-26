# -*- coding: utf-8 -*-

require 'net/http'
require 'json'

module BambooWorker
  # Notification module
  module Notification
    # Base class
    class Base
      attr_reader :opts

      ##
      # Initialize notification options
      #
      # @param [Hash] opts Notification options
      #
      # @return nil
      def initialize(opts)
        @opts = opts
      end

      ##
      # Send notification message
      #
      # @param [Boolean] status Build status
      #          true => success,
      #          false => failed,
      #          nil => No status
      #
      # @return nil
      #
      def notify(_status = nil)
        raise NotImplementedError
      end
    end
  end
end
