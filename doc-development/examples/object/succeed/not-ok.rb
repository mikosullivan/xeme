#!/usr/bin/ruby -w
require 'xeme'

## {"start":"all"}
xeme = Xeme.new
xeme.error 'my-error'
xeme.succeed # => raises exception: `succeed': cannot-set-to-success: errors
## {"end":"all"}

# done
puts '[done]'