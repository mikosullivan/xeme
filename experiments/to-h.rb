#!/usr/bin/ruby -w
require 'xeme'
require 'tatum'
TTM.io = STDOUT
require 'deep_dup'

# instantiate
xeme = Xeme.new()

# messages
xeme.error 'my-error'

# output
puts xeme.to_h

# done
puts '[done]'