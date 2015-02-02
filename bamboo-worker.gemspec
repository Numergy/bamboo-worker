# -*- coding: utf-8 -*-
require File.expand_path('../lib/bamboo-worker/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'bamboo-worker'
  s.version     = BambooWorker::VERSION
  s.date        = '2014-08-19'
  s.authors     = ['Pierre Rambaud']
  s.email       = 'pierre.rambaud86@gmail.com'
  s.license     = 'GPL-3.0'
  s.summary     = 'Convert .travis.yml file to executable bash script.'
  s.homepage    = 'https://github.com/Numergy/bamboo-worker'
  s.description = 'Convert .travis.yml file to executable bash script.'
  s.executables = ['bamboo-worker']

  s.files = File.read(File.expand_path('../MANIFEST', __FILE__)).split("\n")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'builder', '~>3.2'
  s.add_dependency 'erubis', '~> 2.7'
  s.add_dependency 'slop', '~>3.6'
  s.add_dependency 'travis-yaml', '0.1.0'
  s.add_dependency 'psych', '~>2.0.5'

  s.add_development_dependency 'fakefs', '~>0.5'
  s.add_development_dependency 'rake', '~>10.0'
  s.add_development_dependency 'rspec', '~>3.0'
  s.add_development_dependency 'rubocop', '~>0.26'
  s.add_development_dependency 'simplecov', '~>0.9'
  s.add_development_dependency 'rspec_junit_formatter', '~>0.2.0'
end
