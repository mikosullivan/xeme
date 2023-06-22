#!/usr/bin/ruby -w
require 'xeme'
require 'tatum/stdout'

promise = Xeme::Promise.new

promise['success'] = true

puts promise

# done
puts '[done]'