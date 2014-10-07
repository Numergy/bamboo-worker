# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Shell module
  module Shell
    autoload :Dsl, 'bamboo-worker/shell/dsl'
    autoload :Node, 'bamboo-worker/shell/node'
    autoload :Cmd, 'bamboo-worker/shell/cmd'
    autoload :Conditional, 'bamboo-worker/shell/conditional'
    autoload :If, 'bamboo-worker/shell/if'
    autoload :Elif, 'bamboo-worker/shell/elif'
    autoload :Else, 'bamboo-worker/shell/else'

    include Dsl
  end
end
