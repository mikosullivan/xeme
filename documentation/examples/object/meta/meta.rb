#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'xeme'

## {"start":"all"}
xeme = Xeme.new('my-xeme')
puts xeme.meta
## {"end":"all"}

# done
puts '[done]'