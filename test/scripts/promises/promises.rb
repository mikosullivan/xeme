#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.try_succeed on a xeme with nested children.

# get food xeme
food = food_tree()

# loop through xemes checking promises
food.all.each do |xeme|
	if xeme.promised.sum > 0
		Bryton::Lite::Tests.assert_equal xeme.promised.sum, xeme.promises.length
	end
end

# done
Bryton::Lite::Tests.done