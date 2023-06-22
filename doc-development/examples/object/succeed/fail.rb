#!/usr/bin/ruby -w
require 'xeme'

## {"start":"fail"}
xeme = Xeme.new
xeme.fail
puts xeme.success? # => false
## {"end":"fail"}

# done
puts '[done]'