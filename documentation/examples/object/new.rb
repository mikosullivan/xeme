#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb' ## {"skip":true}

##{"start":"basic"}
require 'xeme'
xeme = Xeme.new
puts xeme # => #<Xeme:0x000055586f1340a8>
##{"end":"basic"}

TTM.hr

##{"start":"id"}
xeme = Xeme.new('my-xeme')
puts xeme.id # => my-xeme
##{"end":"id"}


##{"start":"as-hash"}
xeme['errors'] = []
xeme['errors'].push({'id'=>'my-error'})
##{"end":"as-hash"}


# done
puts '[done]'