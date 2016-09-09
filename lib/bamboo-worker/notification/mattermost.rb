# Bamboo worker module
module BambooWorker
  # Notification module
  module Notification
    # Mattermost notification
    class Mattermost < Base
      # Send message to mattermost
      #
      # @param [Boolean] status Build status
      #
      # @return nil
      def notify(status = nil)
        uri = URI(@opts['url']) if @opts['url']
        unless uri
          raise KeyError('Mattermost notification requires at least an URL.')
        end

        payload = { text: formatted_msg(status) }
        payload['username'] = @opts['username'] if @opts['username']
        payload['icon_url'] = @opts['icon_url'] if @opts['icon_url']

        Net::HTTP.post_form(uri, 'payload' => payload.to_json)
      end

      # Build status formatted message
      #
      # @param [Boolean] status Build status
      #
      # @return [String]
      def formatted_msg(status)
        msg = ''
        if status.nil?
          msg << 'Worker message '
        elsif status
          msg << "![OK](#{@opts['icon_success']}) " if @opts['icon_success']
          msg << 'Build success '
        else
          msg << "![FAIL](#{@opts['icon_failure']}) " if @opts['icon_failure']
          msg << 'Build failed '
        end

        msg << "on **#{`hostname`.chomp}**: "
        if ENV.key?('bamboo_buildResultKey')
          msg << "[#{ENV['bamboo_buildResultKey']}]"
          msg << "(#{ENV['bamboo_buildResultsUrl']}) "
          msg << "#{ENV['bamboo_planName']} "
          msg << "[[commits](#{ENV['bamboo_buildResultsUrl']}/commit)] "
          msg << "[[logs](#{ENV['bamboo_buildResultsUrl']}/log)] "
          msg << "[[tests](#{ENV['bamboo_buildResultsUrl']}/test)] "
          msg << "[[artifacts](#{ENV['bamboo_buildResultsUrl']}/artifact)] "
        end

        msg
      end
    end
  end
end
