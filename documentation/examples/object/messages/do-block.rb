#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
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
