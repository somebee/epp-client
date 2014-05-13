# -*- encoding: utf-8 -*-
require File.expand_path('../lib/epp-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'epp-client-norid'
  gem.version       = EPPClient::VERSION
  gem.authors       = ['Sindre Aarsaether']
  gem.email         = ['post@identu.no']
  gem.description   = 'Norid EPP client library.'
  gem.summary       = 'Norid EPP client library'
  gem.homepage       = "https://github.com/somebee/epp-client"

  gem.required_ruby_version = '>= 1.8.7'
  gem.required_rubygems_version = ">= 1.3.6"

  gem.files         = [
    'ChangeLog',
    'Gemfile',
    'MIT-LICENSE',
    'README',
    'Rakefile',
    'epp-client-norid.gemspec',
    'lib/epp-client/norid.rb',
    'vendor/norid/contact-1.0.xsd',
    'vendor/norid/domain-1.0.xsd',
    'vendor/norid/epp-1.0.xsd',
    'vendor/norid/eppcom-1.0.xsd',
    'vendor/norid/host-1.0.xsd',
    'vendor/norid/no-ext-contact-1.0.xsd',
    'vendor/norid/no-ext-domain-1.0.xsd',
    'vendor/norid/no-ext-domain-1.1.xsd',
    'vendor/norid/no-ext-epp-1.0.xsd',
    'vendor/norid/no-ext-host-1.0.xsd',
    'vendor/norid/no-ext-result-1.0.xsd',
  ]

  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']

  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_dependency('nokogiri', '~> 1.4')
  gem.add_dependency('builder',  '>= 2.1.2')
  gem.add_dependency('epp-client-base',  "#{EPPClient::VERSION}")
  gem.add_dependency('epp-client-secdns',  "#{EPPClient::VERSION}")
end
