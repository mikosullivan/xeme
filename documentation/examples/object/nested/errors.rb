#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb' ## {"skip":true}
require 'xeme'

## {"start":"all"}
xeme = Xeme.new

xeme.nest() do |child|
	child.error 'error-1'
end

xeme.try_succeed

puts xeme.success?  # => false
puts xeme.nested[0].success?  # => false
## {"end":"all"}

# done
puts '[done]'