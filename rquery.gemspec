Gem::Specification.new do |s|
  s.name        = 'rquery'
  s.version     = '0.1.0'
  s.summary     = "rQuery accepts json and converts to AR query"
  s.description = ""
  s.authors     = ["Tom Wilson, Kris Windham, Andrew Kennedy"]
  s.email       = 'team@jackrussellsoftware.com'
  s.files       = ["lib/rquery.rb"]
  s.homepage    = 'https://github.com/jackruss/rquery'

  s.add_dependency 'rspec', '~> 2.8.0'
  s.add_dependency 'sinatra', '~> 1.3.2'
  s.add_dependency 'rack', '~> 1.4.1'
  s.add_dependency 'rack-test', '~> 0.6.1'
  s.add_dependency 'sqlite3', '~> 1.3.5'
  s.add_dependency 'activerecord', '~> 3.2.2'
  s.add_dependency 'json', '~> 1.6.3'
end
