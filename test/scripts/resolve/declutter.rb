#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.resolve on a xeme with nested children.

# init
xeme = Xeme.new
xeme.errors

# nest
xeme.nest() do |child|
	child.errors
	
	child.nest() do |grandchild|
		grandchild.errors
	end
end

# resolve
xeme.resolve

# should all have empty errors arrays
xeme.all.each do |x|
	Bryton::Lite::Tests.assert x['errors'].nil?
end

# done
Bryton::Lite::Tests.done