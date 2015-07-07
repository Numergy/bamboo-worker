module Travis
  module Yaml
    module Nodes
      ##
      # Mapping "container" to "docker" node
      #
      class Docker < OpenMapping
        map :container, to: Scalar[:str]

        ##
        # Only allow mappings keys
        #
        def accept_key?(key)
          self.class.mapping.include?(key)
        end
      end

      ##
      # Mapping "docker" to root node
      #
      class Root
        map :docker, to: Docker
      end
    end
  end
end
