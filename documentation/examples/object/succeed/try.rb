#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb' ## {"skip":true}
require 'xeme'

## {"start":"succeed"}
xeme = Xeme.new
xeme.try_succeed
puts xeme.success? # => true
## {"end":"succeed"}

## {"start":"fail"}
xeme = Xeme.new
xeme.error 'my-error'
xeme.try_succeed
puts xeme.success? # => false
## {"end":"fail"}

# done
puts '[done]'