#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.try_succeed on a xeme with nested children.

# get food xeme
food = food_tree()

# try_succeed
food.try_succeed

# test each xeme's success against its expected resolved value
food.all.each do |xeme|
	# TESTING
	if xeme['success'] != xeme.tried
		TTM.hr(xeme.id) do
			puts 'success: ' + xeme['success'].class.to_s
			puts 'tried: ' + xeme.tried.to_s
		end
	end
	
	Bryton::Lite::Tests.assert_equal xeme['success'], xeme.tried
end

# done
Bryton::Lite::Tests.done