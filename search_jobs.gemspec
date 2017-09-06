# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'search_jobs/version'

Gem::Specification.new do |spec|
  spec.name          = "search_jobs-cli-gem"
  spec.version       = SearchJobs::VERSION
  spec.authors       = ["'Omar Donnadieu Mercado'"]
  spec.email         = ["'donnadieu.86@gmail.com'"]
  spec.files         = ["lib/search_jobs.rb"]
  spec.summary       = %q{: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/Donnadieu/oo-search_jobs"
  spec.license       = 'MIT'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec~> 0', '~> 0'
  spec.add_development_dependency 'mechanize~> 0', '~> 0'
  spec.add_development_dependency 'pry~> 0', '~> 0'
  spec.add_development_dependency 'io' '0.0.1'

  spec.files         = ["lib/search_jobs.rb", "lib/search_jobs/cli.rb", "lib/search_jobs/scraper.rb", "lib/search_jobs/jobs.rb", "config/environment.rb"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = ['search_jobs']
  spec.require_paths = ["lib", "lib/search_jobs"]
end
