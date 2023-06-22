#!/usr/bin/ruby -w
require 'xeme'

## {"start":"succeed"}
xeme = Xeme.new
xeme.try_succeed
puts xeme.success? # => true
## {"end":"succeed"}

## {"start":"fail"}
xeme = Xeme.new
xeme.fail
xeme.try_succeed
puts xeme.success? # => false
## {"end":"fail"}

# done
puts '[done]'