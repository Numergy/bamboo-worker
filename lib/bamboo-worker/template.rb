# -*- coding: utf-8 -*-
module BambooWorker
  # Render template
  class Template
    # Static: Render template with Erubis
    #
    # Example:
    #   BambooWorker::Template.render('Hello <%= title %>', {title: 'GoT'})
    #   # => "Hello GoT"
    #
    # @param [String] template Template string to used for rendering
    # @param [String] data Data binding
    # @return [String]
    #
    def self.render(template, data = {})
      eruby = Erubis::Eruby.new(template)
      output = eruby.result(data)
      output
    end
  end
end
