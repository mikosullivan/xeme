#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.resolve on a xeme with nested children.

# get food xeme
food = food_tree()

# resolve
food.resolve

# test each xeme's success against its expected resolved value
food.all.each do |xeme|
  Bryton::Lite::Tests.assert_equal xeme['success'], xeme.resolved
end

# done
Bryton::Lite::Tests.done