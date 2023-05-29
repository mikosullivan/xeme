#!/usr/bin/ruby -w
require_relative './dir.rb'

# Test #succeed and #fail

# succeed
xeme = Xeme.new()
xeme.succeed
Bryton::Lite::Tests.assert xeme.success?

# fail explicitly
xeme = Xeme.new()
xeme.fail
Bryton::Lite::Tests.refute xeme.success?

# fail with errors
xeme = Xeme.new()
xeme.error 'my-error'
Bryton::Lite::Tests.refute xeme.success?

# done
Bryton::Lite::Tests.done