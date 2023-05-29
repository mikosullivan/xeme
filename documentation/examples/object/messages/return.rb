#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'xeme'
xeme = Xeme.new

## {"start":"all"}
err = xeme.error('my-error')
err['database-error'] = 'some database error'
err['commands'] = ['a', 'b', 'c']
## {"end":"all"}


# done
puts '[done]'
