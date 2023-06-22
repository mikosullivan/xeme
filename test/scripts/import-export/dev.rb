#!/usr/bin/ruby -w
require 'timecop'
require 'tatum/stdout'
require 'json'
require 'hashie_walker'

# slurp in hash
hsh = JSON.parse( File.read('./expected.json') )

# walk structure
HashieWalker.walk(hsh) do |map|
  puts map.class
end

# done
puts '[done]'