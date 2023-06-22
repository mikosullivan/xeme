Gem::Specification.new do |spec|
  spec.name        = 'xeme'
  spec.version     = '2.0'
  spec.date        = '2023-06-22'
  spec.summary     = 'Xeme'
  spec.description = 'Standard structure for reporting results of an operation.'
  spec.authors     = ["Mike O'Sullivan"]
  spec.email       = 'mike@idocs.com'
  spec.homepage    = 'https://github.com/mikosullivan/xeme'
  spec.license     = 'MIT'
  
  # spec.add_runtime_dependency 'declutter', '~> 1.1'
  spec.add_development_dependency 'timecop', '~> 0.9.6'
  spec.add_development_dependency 'structverse', '~> 1.0'
  
  spec.files = [
    'lib/xeme.rb',
    'README.md',
  ]
end