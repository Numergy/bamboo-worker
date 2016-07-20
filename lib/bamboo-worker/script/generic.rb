# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script module
  class Script
    # Generic language
    class Generic < Default
      # Announce generic
      def announce
        cmd 'bash --version', echo: true
      end
    end
  end
end
