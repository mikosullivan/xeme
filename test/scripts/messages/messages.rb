#!/usr/bin/ruby -w
require_relative './dir.rb'


# Tests getting arrays and hashes of messages.


#-------------------------------------------------------------------------------
# ids
#
def ids
  return ['a', 'b']
end
#
# ids
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# message_test
#
def message_test(singular)
  plural = "#{singular}s"
  top singular, plural
  nested singular, plural
end
#
# message_test
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# top
#
def top(singular, plural)
  # current xeme
  xeme = Xeme.new()
  Bryton::Lite::Tests.refute xeme[plural]
  
  # add messages
  ids.each do |id|
    xeme.send(singular, id)
  end
  
  # test length of messages array
  Bryton::Lite::Tests.assert xeme[plural]
  Bryton::Lite::Tests.assert_equal ids.length, xeme[plural].length
  Bryton::Lite::Tests.assert_equal ids[0], xeme[plural][0]['id']
  Bryton::Lite::Tests.assert_equal ids[1], xeme[plural][1]['id']
  
  # test length of messages method with id
  Bryton::Lite::Tests.assert_equal 1, xeme.send(plural, ids[0]).length
  
  # test messages hash
  Bryton::Lite::Tests.assert_equal ids.length, xeme.send("#{plural}_hash").length
  Bryton::Lite::Tests.assert_equal ids, xeme.send("#{plural}_hash").keys
  
  # loop through messages hash
  xeme.send("#{plural}_hash").each do |k, msgs|
    Bryton::Lite::Tests.assert_equal 1, msgs.length
  end
end
#
# top
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# nested
#
def nested(singular, plural)
  # populate nested xeme
  xeme = nester() do |x|
    ids.each do |id|
      x.send singular, id
    end
  end
  
  # count all messages
  Bryton::Lite::Tests.assert_equal nester_max(ids.length), xeme.send(plural).length
  
  # count just messages with a specific id
  Bryton::Lite::Tests.assert_equal nester_max(), xeme.send(plural, ids[0]).length
  
  # test messages hash
  Bryton::Lite::Tests.assert_equal ids.length, xeme.send("#{plural}_hash").length
  Bryton::Lite::Tests.assert_equal ids, xeme.send("#{plural}_hash").keys
  
  # loop through messages hash
  xeme.send("#{plural}_hash").each do |k, msgs|
    Bryton::Lite::Tests.assert_equal nester_max, msgs.length
  end
end
#
# nested
#-------------------------------------------------------------------------------


# message tests
message_test 'error'
message_test 'warning'
message_test 'note'
message_test 'promise'

# done
Bryton::Lite::Tests.done