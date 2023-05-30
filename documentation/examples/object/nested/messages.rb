#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'xeme'

## {"start":"errors"}
xeme = Xeme.new
xeme.error 'outer-error'

xeme.nest do |child|
  child.error 'child-error'
end

puts xeme.errors

# => {"id"=>"outer-error"}
# => {"id"=>"child-error"}
## {"end":"errors"}


TTM.hr


## {"start":"id"}
puts xeme.errors('child-error') # => {"id"=>"child-error"}
## {"end":"id"}


TTM.hr


## {"start":"flatten"}
puts xeme['errors']
# => {"id"=>"outer-error"}

xeme.flatten

puts xeme['errors']
# => {"id"=>"outer-error"}
# => {"id"=>"child-error"}
## {"end":"flatten"}

# done
puts '[done]'