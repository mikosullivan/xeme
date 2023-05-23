#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests #all_errors, #all_warnings, #all_notes


#-------------------------------------------------------------------------------
# test_all_messages
#
def test_all_messages(singular)
	plural = "#{singular}s"
	
	# init
	xeme = Xeme.new
	
	# add own message
	xeme.send(singular)
	
	# nest
	xeme.nest() do |child|
		child.send(singular)
		
		child.nest() do |grandchild|
			grandchild.send(singular)
			grandchild.send(singular)
		end
	end
	
	# should have four messages
	Bryton::Lite::Tests.assert_equal 4, xeme.send("all_#{plural}").length
end
#
# test_all_messages
#-------------------------------------------------------------------------------


# test all[messsage]s
test_all_messages 'error'
test_all_messages 'warning'
test_all_messages 'note'

# done
Bryton::Lite::Tests.done