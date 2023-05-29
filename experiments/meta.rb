#!/usr/bin/ruby -w
require_relative './dir.rb'

# instantiate
xeme = Xeme.new()
xeme.meta

# output
puts xeme.to_json

# done
puts '[done]'