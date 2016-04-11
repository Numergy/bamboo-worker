# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Logger class
  class Logger
    ##
    # Hash containing available level for logger
    #
    # @return [Hash]
    #
    LEVELS = {
      'debug' => ::Logger::DEBUG,
      'info' => ::Logger::INFO,
      'warn' => ::Logger::WARN,
      'error' => ::Logger::ERROR,
      'fatal' => ::Logger::FATAL,
      'unknown' => ::Logger::UNKNOWN
    }.freeze

    attr_reader :logger

    ##
    # Initialize logger
    #
    def self.logger
      if @logger.nil?
        l = ::Logger.new(STDOUT)
        l.level = LEVELS['info']
        l.datetime_format = '%Y-%m-%d %H:%M:%S'
        @logger = l
      end

      @logger
    end

    ##
    # Change logger level
    #
    # @param [String] level Level
    #
    def self.level(level)
      logger.level = LEVELS[level] if LEVELS.key?(level)
    end

    ##
    # Send debug message to logger
    #
    # @param [String] message Message to write
    #
    def self.debug(message)
      logger.debug(message)
    end

    ##
    # Send error message to logger
    #
    # @param [String] message Message to write
    #
    def self.error(message)
      logger.error(message)
    end

    ##
    # Send info message to logger
    #
    # @param [String] message Message to write
    #
    def self.info(message)
      logger.info(message)
    end

    ##
    # Send fatal message to logger
    #
    # @param [String] message Message to write
    #
    def self.fatal(message)
      logger.fatal(message)
    end

    ##
    # Send warning message to logger
    #
    # @param [String] message Message to write
    #
    def self.warn(message)
      logger.warn(message)
    end

    ##
    # Send unknown message to logger
    #
    # @param [String] message Message to write
    #
    def self.unknown(message)
      logger.unknown(message)
    end
  end
end
