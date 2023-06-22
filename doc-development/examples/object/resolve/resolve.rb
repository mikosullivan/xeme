#!/usr/bin/ruby -w
require 'xeme'

## {"start":"resolve"}
xeme.resolve
## {"end":"resolve"}

## {"start":"try"}
xeme.try_succeed
puts xeme.success? # => true, false, or nil
## {"end":"try"}

# done
puts '[done]'