#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.resolve on a xeme with no nested children.

# init
xeme = Xeme.new

# add errors
Bryton::Lite::Tests.refute xeme.hsh['errors']
xeme.error
Bryton::Lite::Tests.assert xeme.errors.any?
Bryton::Lite::Tests.assert xeme.failure?
Bryton::Lite::Tests.assert xeme['success'].nil?

# resolve
xeme.resolve

# should have explicit success=false
Bryton::Lite::Tests.assert xeme['success'].is_a?(FalseClass)

# done
Bryton::Lite::Tests.done