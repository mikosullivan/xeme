#!/usr/bin/ruby -w
require_relative './dir.rb'

#-------------------------------------------------------------------------------
# test_message
#
def test_message(singular)
	# puts singular
	
	plural = "#{singular}s"
	count = 10
	
	# instantiate
	xeme = Xeme.new()
	current = xeme
	
	# nest
	count.times do |idx|
		current.send singular, idx
		current = current.nest
	end
	
	# flatten
	xeme.flatten
	
	# should have all messages in own array
	Bryton::Lite::Tests.assert_equal count, xeme[plural].length
end
#
# test_message
#-------------------------------------------------------------------------------


# test types of messages
test_message 'error'
test_message 'warning'
test_message 'note'
test_message 'promise'

# done
Bryton::Lite::Tests.done