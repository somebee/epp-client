# -*- encoding: utf-8 -*-
require File.expand_path('../lib/epp-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'epp-client-secdns'
  gem.version       = EPPClient::VERSION
  gem.authors       = ['Mathieu Arnold']
  gem.email         = ['m@absolight.fr']
  gem.description   = 'SecDNS EPP client library.'
  gem.summary       = 'SecDNS EPP client library'
  gem.homepage       = "https://github.com/Absolight/epp-client"

  gem.required_ruby_version = '>= 1.8.7'
  gem.required_rubygems_version = ">= 1.3.6"

  gem.files         = [
    'ChangeLog',
    'Gemfile',
    'MIT-LICENSE',
    'README',
    'Rakefile',
    'epp-client-secdns.gemspec',
    'lib/epp-client/secdns.rb',
    'vendor/ietf/rfc4310.txt',
    'vendor/ietf/rfc5910.txt',
    'vendor/ietf/secDNS-1.0.xsd',
    'vendor/ietf/secDNS-1.1.xsd',
  ]

  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']

  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_dependency('nokogiri', '~> 1.4')
  gem.add_dependency('builder',  '>= 2.1.2')
end
