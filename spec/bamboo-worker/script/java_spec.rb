# -*- coding: utf-8 -*-
require 'spec_helper'
require 'travis/yaml'
require 'bamboo-worker/shell'
require 'bamboo-worker/script/default'
require 'bamboo-worker/script/java'

# Bamboo worker tests
module BambooWorker
  # java script tests
  describe 'Script::Java' do
    before(:each) do
      travis = Travis::Yaml.matrix('language: java
jdk: 6')
      @java = Script::Java.new(travis.first)
    end

    it 'should setup' do
      @java.setup
      expect(@java.nodes.map(&:to_s))
        .to eq(["export JENV_VERSION=$(jenv versions | grep ' 1.6 ' " \
                "| tail -1 | sed 's/[^0-9.]*\\([0-9.]*\\).*/\\1/'| " \
                "sed -e 's/^[ \\t]*//')",
                "if [[ -z \"$JENV_VERSION\" ]]; then\n  export " \
                "BAMBOO_CMD=no_script\n  echo 'Java version \\''6\\'' " \
                "not found'\n  exit 1\nfi",
                'export BAMBOO_JAVA_VERSION=6'])
    end

    it 'should announce' do
      @java.announce
      expect(@java.nodes.map(&:to_s))
        .to eq(['bamboo_cmd jenv\\ --version --echo',
                'bamboo_cmd java\\ --version --echo',
                'bamboo_cmd javac\\ --version --echo',
                'bamboo_cmd mvn\\ --version --echo'])
    end

    it 'should install' do
      @java.install
      expect(@java.nodes.map(&:to_s))
        .to eq(["if [[ -f pom.xml ]]; then\n  " \
                'bamboo_cmd mvn\\ install\\ -DskipTests\\=true\\' \
                " -Dmaven.javadoc.skip\\=true\\ -B\\ -V --retry\nfi"])
    end

    it 'should script' do
      @java.script
      expect(@java.nodes.map(&:to_s))
        .to eq(["if [[ -f pom.xml ]]; then\n  " \
                "mvn test -B\nelse\n  " \
                "echo 'Could not locate pom.xml file'\nfi"])
    end
  end
end
