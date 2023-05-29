#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb' ## {"skip":true}
require 'xeme'

## {"start":"all"}
xeme = Xeme.new
xeme.succeed
puts xeme.success?  # => true
## {"end":"all"}

# done
puts '[done]'