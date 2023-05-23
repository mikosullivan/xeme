#!/usr/bin/ruby -w
require_relative './dir.rb'


#-------------------------------------------------------------------------------
# message_test
#
def message_test(singular)
	top singular
	nested singular
end
#
# message_test
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# top
#
def top(singular)
	# message id
	msg_id = "my-#{singular}"
	
	# current xeme
	xeme = Xeme.new()
	Bryton::Lite::Tests.refute xeme.send("#{singular}s?")
	
	# add message
	xeme.send(singular, msg_id)
	
	# test messages in top xeme
	Bryton::Lite::Tests.assert xeme.send("#{singular}s?")
	Bryton::Lite::Tests.assert xeme.send("#{singular}s").any?
	Bryton::Lite::Tests.assert_equal msg_id, xeme.send("#{singular}s")[0]['id']
end
#
# top
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# nested
#
def nested(singular)
	xeme = Xeme.new()
	
	# nest message
	xeme.nest() do |child|
		child.nest() do |grandchild|
			grandchild.send(singular)
		end
	end
	
	# check for message
	Bryton::Lite::Tests.assert xeme.send("#{singular}s?")
end
#
# nested
#-------------------------------------------------------------------------------



# message tests
message_test 'error'
message_test 'warning'
message_test 'note'

# done
Bryton::Lite::Tests.done