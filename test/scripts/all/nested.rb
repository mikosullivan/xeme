#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.resolve on a xeme with nested children.

# init
xeme = Xeme.new

# nest
xeme.nest() do |child|
	child.nest() do |grandchild|
		grandchild.error
	end
end

# resolve
xeme.resolve

# should have explicit success=false
Bryton::Lite::Tests.assert xeme['success'].is_a?(FalseClass)
Bryton::Lite::Tests.assert xeme.nested[0]['success'].is_a?(FalseClass)
Bryton::Lite::Tests.assert xeme.nested[0].nested[0]['success'].is_a?(FalseClass)

# done
Bryton::Lite::Tests.done