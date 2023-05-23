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
Bryton::Lite::Tests.assert xeme.failure?

# fail with errors
xeme = Xeme.new()
xeme.error
Bryton::Lite::Tests.refute xeme.success?
Bryton::Lite::Tests.assert xeme.failure?

# done
Bryton::Lite::Tests.done