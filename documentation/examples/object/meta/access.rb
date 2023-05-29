#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'xeme'

## {"start":"all"}
xeme = Xeme.new
xeme.meta['foo'] = 'bar'
xeme.meta.class # => Hash
## {"end":"all"}

# done
puts '[done]'