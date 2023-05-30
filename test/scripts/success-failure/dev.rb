#!/usr/bin/ruby -w
require_relative './dir.rb'

# method
# method = 'resolve'
method = 'try_succeed'

# fosberg
# TTM.hrd('fosberg') do
#   food = food_tree()
#   fosberg = food.all('fosberg')[0]
#   fosberg.send(method)
#   
#   puts fosberg['success'].class
#   puts fosberg.success?.class
# end

puts

# breadfruit
TTM.hrd('breadfruit') do
  food = food_tree()
  breadfruit = food.all('breadfruit')[0]
  breadfruit.send(method)
  
  puts breadfruit['success'].class
  puts breadfruit.success?.class
end

# done
puts '[done]'