#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'xeme'

## {"start":"top"}
xeme = Xeme.new

xeme.promise('my-promise') do |promise|
	promise['uri'] = 'https://example.com/4325rsa'
	puts promise # => {"id"=>"my-promise", "uri"=>"https://example.com/4325rsa"}
end

puts xeme.promises.length # => 1
## {"end":"top"}

TTM.hr


## {"start":"nested"}
xeme = Xeme.new

xeme.promise 'top-promise'

xeme.nest() do |child|
	child.promise 'child-promise'
end

puts xeme.promises.length # => 2
## {"end":"nested"}

# done
puts '[done]'