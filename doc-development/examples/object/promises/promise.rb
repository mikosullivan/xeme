#!/usr/bin/ruby -w
require 'xeme'

## {"start":"top"}
xeme = Xeme.new

xeme.promise('my-promise') do |promise|
	promise['uri'] = 'https://example.com/4325rsa'
	puts promise # => {"id"=>"my-promise", "uri"=>"https://example.com/4325rsa"}
end

puts xeme.promises.length # => 1
## {"end":"top"}


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