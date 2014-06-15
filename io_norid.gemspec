# -*- encoding: utf-8 -*-
require File.expand_path('../lib/epp-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'io_norid'
  gem.version       = '1.0'
  gem.authors       = ['Sindre Aarsaether']
  gem.email         = ['post@identu.no']
  gem.description   = 'Norid EPP client library for IO'
  gem.summary       = 'Norid EPP client library for IO'
  gem.homepage       = "https://github.com/somebee/epp-client"

  gem.required_ruby_version = '>= 1.8.7'
  gem.required_rubygems_version = ">= 1.3.6"

  gem.files         = [
    'ChangeLog',
    'Gemfile',
    'MIT-LICENSE',
    'README',
    'Rakefile',
    'io_norid.gemspec',
    'lib/epp-client/base.rb',
    'lib/epp-client/connection.rb',
    'lib/epp-client/contact.rb',
    'lib/epp-client/domain.rb',
    'lib/epp-client/exceptions.rb',
    'lib/epp-client/poll.rb',
    'lib/epp-client/session.rb',
    'lib/epp-client/ssl.rb',
    'lib/epp-client/version.rb',
    'lib/epp-client/xml.rb',
    'lib/epp-client/norid.rb',

    'vendor/ietf/contact-1.0.xsd',
    'vendor/ietf/domain-1.0.xsd',
    'vendor/ietf/epp-1.0.xsd',
    'vendor/ietf/eppcom-1.0.xsd',
    'vendor/ietf/host-1.0.xsd',
    'vendor/ietf/rfc4310.txt',
    'vendor/ietf/rfc5730.txt',
    'vendor/ietf/rfc5731.txt',
    'vendor/ietf/rfc5732.txt',
    'vendor/ietf/rfc5733.txt',
    'vendor/ietf/rfc5734.txt',
    'vendor/ietf/rfc5910.txt',

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

    'lib/epp-client/secdns.rb',
    'vendor/ietf/rfc4310.txt',
    'vendor/ietf/rfc5910.txt',
    'vendor/ietf/secDNS-1.0.xsd',
    'vendor/ietf/secDNS-1.1.xsd'
  ]

  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']

  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_dependency('nokogiri', '~> 1.4')
  gem.add_dependency('builder',  '>= 2.1.2')
end
