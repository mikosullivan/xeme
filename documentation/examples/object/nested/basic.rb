#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb' ## {"skip":true}
require 'xeme'

## {"start":"just-nest"}
xeme = Xeme.new('results')
xeme.nest 'child-xeme'
## {"end":"just-nest"}


xeme = Xeme.new('results')

## {"start":"do-block"}
xeme.nest('child-xeme') do |child|
	child.error 'child-error'
end
## {"end":"do-block"}




# done
puts '[done]'