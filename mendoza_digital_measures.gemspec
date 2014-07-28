$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'mendoza_digital_measures/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'mendoza_digital_measures'
  s.version     = MendozaDigitalMeasures::VERSION
  s.authors     = ['Alec Hipshear']
  s.email       = ['ahipshea@nd.edu']
  s.homepage    = 'http://github.com/ndwebgroup'
  s.summary     = "Access to Mendoza's DigitalMeasures repository"
  s.description = ''

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 3.2.18'
  s.add_dependency 'nokogiri'
  s.add_dependency 'typhoeus'
  s.add_dependency 'dotenv'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry-byebug'
end