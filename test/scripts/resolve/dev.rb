#!/usr/bin/ruby -w
require_relative './dir.rb'
require_relative './food.rb'

# get xeme
food = create_food

# show food tree
food.info

# done
puts '[done]'