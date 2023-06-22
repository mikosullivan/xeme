#!/usr/bin/ruby -w
require 'xeme'
require 'tatum/stdout'
require_relative '../../helper.rb'

puts "don't run this again unless you need to change the expected values"
exit

# freeze time
Timecop.freeze do
  # xeme for comparison
  xeme = Xeme.new
  xeme.init_meta
  xeme.error.init_meta
  xeme.success.init_meta
  xeme.warning.init_meta
  xeme.note.init_meta
  xeme.promise.init_meta
  
  # output expected structure
  File.write 'expected.json', JSON.pretty_generate( JSON.parse(xeme.to_json) )
  
  # output envronment
  env = {'timestamp': xeme.timestamp}
  File.write 'environment.json', env.to_json
end