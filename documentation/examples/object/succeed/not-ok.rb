#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb' ## {"skip":true}
require 'xeme'

## {"start":"all"}
xeme = Xeme.new
xeme.error 'my-error'
xeme.succeed # => raises exception: `succeed': cannot-set-to-success: errors
## {"end":"all"}

# done
puts '[done]'