#!/usr/bin/ruby -w
require 'xeme'
xeme = Xeme.new

## {"start":"all"}
xeme.error('my-error') do |error|
	error['database-error'] = 'some database error'
	error['commands'] = ['a', 'b', 'c']
end
## {"end":"all"}


# done
puts '[done]'
