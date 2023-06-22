#!/usr/bin/ruby -w
require 'xeme'

## {"start":"all"}
xeme = Xeme.new
puts xeme.success?.class # => NilClas
## {"end":"all"}

# done
puts '[done]'