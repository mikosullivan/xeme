#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.resolve on a xeme with nested children.

# message keys
msg_keys = ['errors', 'warnings', 'notes']

# get food xeme
food = food_tree

# TESTING
# food.all.each do |xeme|
# 	msg_keys.each do |k|
# 		if xeme[k]
# 			puts xeme[k].length
# 		end
# 	end
# end

# declutter
food.declutter

# should not have any empty arrays
food.all.each do |xeme|
	msg_keys.each do |k|
		if xeme[k]
			Bryton::Lite::Tests.assert xeme[k].any?
		end
	end
end

# done
Bryton::Lite::Tests.done