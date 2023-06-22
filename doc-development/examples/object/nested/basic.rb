#!/usr/bin/ruby -w
require 'xeme'

xeme = Xeme.new()

## {"start":"do-block"}
xeme.nest() do |child|
  # do stuff with nested xeme
end
## {"end":"do-block"}

xeme = Xeme.new()

## {"start":"return"}
child = xeme.nest()
## {"end":"return"}

# done
puts '[done]'