Gem::Specification.new do |s|
  s.name        = 'rquery'
  s.version     = '0.1.0'
  s.summary     = "Queries for your restful api!"
  s.description = "Rquery is a ruby gem that will allow you to pass queries into your restful api as json.  It will take the json formatted queries and convert them into an orm or datasource specific query (currently only ActiveRecord is supported)."
  s.authors     = ["Tom Wilson, Kris Windham, Andrew Kennedy"]
  s.email       = 'team@jackrussellsoftware.com'
  s.files       = ["lib/rquery.rb"]
  s.homepage    = 'https://github.com/jackruss/rquery'

  s.add_dependency 'json', '~> 1.6.3'
end
