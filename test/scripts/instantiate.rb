#!/usr/bin/ruby -w
require_relative './dir.rb'

# instantiate
xeme = Xeme.new()
Bryton::Lite::Tests.assert xeme.hsh.is_a?(Hash)

# respond to
Bryton::Lite::Tests.assert xeme.respond_to?('[]')
Bryton::Lite::Tests.assert xeme.respond_to?('[]=')
Bryton::Lite::Tests.assert xeme.respond_to?('each')
Bryton::Lite::Tests.assert xeme.respond_to?('length')
Bryton::Lite::Tests.assert xeme.respond_to?('clear')

# done
Bryton::Lite::Tests.done