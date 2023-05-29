#!/usr/bin/ruby -w
require_relative './dir.rb'


# Tests that adding an error sets success to false.

# xeme
xeme = Xeme.new
Bryton::Lite::Tests.assert_equal nil, xeme['success']
Bryton::Lite::Tests.assert_equal nil, xeme.success?

xeme.succeed
Bryton::Lite::Tests.assert xeme['success']
Bryton::Lite::Tests.assert xeme.success?

xeme.error 'my-error'
Bryton::Lite::Tests.assert_equal false, xeme['success']
Bryton::Lite::Tests.assert_equal false, xeme.success?

# done
Bryton::Lite::Tests.done