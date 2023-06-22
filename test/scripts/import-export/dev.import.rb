#!/usr/bin/ruby -w
require 'xeme'
require 'tatum/stdout'
require_relative '../../helper.rb'

# config
src = 'exported.json'

# get raw JSON
json = File.read(src)

# import
xeme = Xeme.import(json)
puts xeme.timestamp.class

# done
# puts '[done]'