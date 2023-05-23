#!/usr/bin/ruby -w
require_relative './dir.rb'

# fail to succeed
xeme = Xeme.new()
xeme.error

# attempt at success should raise exception
Bryton::Lite::Tests.exception do
	xeme.succeed
end

# done
Bryton::Lite::Tests.done