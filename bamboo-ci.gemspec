# -*- coding: utf-8 -*-
require File.expand_path('../lib/bamboo-ci/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'bamboo-ci'
  s.version     = BambooCi::VERSION
  s.date        = '2014-08-19'
  s.authors     = ['Pierre Rambaud']
  s.email       = 'pierre.rambaud86@gmail.com'
  s.license     = 'GPL-3.0'
  s.summary     = 'Convert .travis.yml file to executable bash script.'
  s.homepage    = 'https://github.com/Numergy/bamboo-ci'
  s.description = 'Convert .travis.yml file to executable bash script.'
  s.executables = ['bamboo-ci']

  s.files = File.read(File.expand_path('../MANIFEST', __FILE__)).split("\n")

  s.required_ruby_version = '~> 1.9.3'

  s.add_dependency 'travis-yaml', '~>0.1'
  s.add_dependency 'builder', '~>3.2'

  s.add_development_dependency 'rake', '~>10.0'
  s.add_development_dependency 'rspec', '~>3.0'
  s.add_development_dependency 'simplecov', '~>0.9'
  s.add_development_dependency 'rubocop', '~>0.26'
end
