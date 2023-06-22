#!/usr/bin/ruby -w
require 'xeme'

## {"start":"all"}
xeme = Xeme.new
xeme.meta['foo'] = 'bar'
xeme.meta.class # => Hash
## {"end":"all"}

# done
puts '[done]'