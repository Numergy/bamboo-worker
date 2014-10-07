module BambooWorker
  module Script
    # Default task for python language
    class Python
      def install
        'pip install -r Requirements.txt' if File.exist?('Requirements.txt')
        'pip install -r requirements.txt' if File.exist?('requirements.txt')
        'Could not locate requirements.txt. ' \
        'Override the install: key in your .travis.yml to install dependencies.'
      end
    end
  end
end
