# -*- coding: utf-8 -*-
# Bamboo worker module
module BambooWorker
  # Script module
  class Script
    # Java language
    class Java < Default
      # Setup language with jenv
      #
      def setup
        super
        export('JENV_VERSION', '$(jenv versions ' \
               "| grep ' 1.#{@config.jdk}' " \
               "| tail -1 | sed 's/[^0-9.]*\\([0-9.]*\\).*/\\1/'" \
               "| sed -e 's/^[ \\t]*//')")
        self.if('-z "$JENV_VERSION"') do |klass|
          klass.failure("Java version '#{@config.jdk}' not found")
        end

        export('BAMBOO_JAVA_VERSION', @config.jdk, echo: false)
      end

      # Announce java and mvn version
      #
      def announce
        cmd('jenv --version', echo: true)
        cmd('java -version', echo: true)
        cmd('javac -version', echo: true)
        cmd('mvn --version', echo: true)
      end

      # Default install action for node js
      #
      def install
        self.if('-f pom.xml') do |klass|
          klass.cmd('mvn install -DskipTests=true' \
                    ' -Dmaven.javadoc.skip=true -B -V', retry: true)
        end
      end

      # Default test script for java
      #
      def script
        self.if('-f pom.xml') do |klass|
          klass.cmd('mvn test -B')
        end
        self.else do |klass|
          klass.echo('Could not locate pom.xml file')
        end
      end
    end
  end
end
