#!/usr/bin/ruby -w
require 'xeme'
require 'tatum/stdout'

## {"start":"setup"}
xeme = Xeme.new()
xeme.id = 'top'

xeme.nest() do |child|
  child.id = 'foo'
  
  child.nest() do |grandchild|
    grandchild.id = 'bar'
    grandchild.warning.id = 'my-warning'
    grandchild.promise.id = 'my-promise'
    grandchild.success
  end
  
  child.error.id = 'my-error'
  child.note.id = 'my-note'
end
## {"end":"setup"}

## {"start":"all"}
xeme.all.each do |x|
	puts x.id
end

# => top
# => foo
# => bar
# => my-warning
# => my-promise
# => my-error
# => my-note
## {"end":"all"}

TTM.hr 'types'

## {"start":"types"}
puts xeme.warnings.length # => 1
puts xeme.notes.length # => 2
puts xeme.promises.length # => 1
## {"end":"types"}

TTM.hr 'statuses'

## {"start":"statuses"}
# xemes marked as success=false
puts xeme.errors.length # => 3

# xemes marked as success=true
puts xeme.successes.length # => 1

# xemes marked as success=null
# does not return advisory xemes
puts xeme.nils.length # => 2
## {"end":"statuses"}

# done
puts '[done]'