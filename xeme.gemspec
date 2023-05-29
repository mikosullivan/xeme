Gem::Specification.new do |spec|
	spec.name        = 'xeme'
	spec.version     = '1.0'
	spec.date        = '2023-05-29'
	spec.summary     = 'Xeme'
	spec.description = 'Standard structrure for reporting results of an operation.'
	spec.authors     = ["Mike O'Sullivan"]
	spec.email       = 'mike@idocs.com'
	spec.homepage    = 'https://github.com/mikosullivan/xeme'
	spec.license     = 'MIT'
	
	spec.add_runtime_dependency 'bryton-lite', '~> 1.1'
	
	spec.files = [
		'lib/xeme.rb',
		'README.md',
	]
end