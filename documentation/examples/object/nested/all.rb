#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb' ## {"skip":true}
require 'xeme'

xeme = Xeme.new('results')
xeme.nest 'child-xeme'

## {"start":"all"}
xeme.all.each do |x|
  puts x.id
end
## {"end":"all"}

# done
puts '[done]'