#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.all.

# init
xeme = Xeme.new

# nest
xeme.nest() do |child|
	child.nest() do |grandchild|
	end
end

# should have three xemes
Bryton::Lite::Tests.assert_equal 3, xeme.all.length

# done
Bryton::Lite::Tests.done