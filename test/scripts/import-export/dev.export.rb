#!/usr/bin/ruby -w
require 'xeme'
require 'tatum/stdout'
require_relative '../../helper.rb'

xeme = Xeme.new
xeme.error.init_meta
xeme.success.init_meta
xeme.warning.init_meta
xeme.note.init_meta
xeme.promise.init_meta
puts JSON.pretty_generate( JSON.parse(xeme.to_json) )

# done
# puts '[done]'