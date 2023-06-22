#!/usr/bin/ruby -w
require 'xeme'

## {"start":"all"}
xeme = Xeme.new
xeme.succeed
puts xeme.success?  # => true
## {"end":"all"}

# done
puts '[done]'