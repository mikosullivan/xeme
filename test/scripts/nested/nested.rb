#!/usr/bin/ruby -w
require_relative './dir.rb'

# instantiate
xeme = Xeme.new()

# nest
xeme.nest() do |child|
	Bryton::Lite::Tests.assert child.is_a?(Xeme)
end

# done
Bryton::Lite::Tests.done