#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.resolve on a xeme with no nested children.

# init
xeme = Xeme.new

# success should be nil
Bryton::Lite::Tests.assert xeme['success'].nil?

# set to success
xeme.succeed
Bryton::Lite::Tests.assert xeme['success']

# add error
xeme.error 'my-error'

# resolve
xeme.resolve

# success should be false
Bryton::Lite::Tests.assert xeme['success'].is_a?(FalseClass)

# done
Bryton::Lite::Tests.done