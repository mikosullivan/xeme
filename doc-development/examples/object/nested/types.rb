#!/usr/bin/ruby -w
require 'xeme'
require 'tatum/stdout'

TTM.hr('success')
xeme = Xeme.new()

## {"start":"all"}
xeme.success() do |child|
  puts child.success? # => true
end

xeme.error() do |child|
  puts child.success? # => false
end

# Xeme#failure does same thing as Xeme#error
xeme.failure() do |child|
  puts child.success? # => false
end

xeme.warning() do |child|
  puts child.class # => Xeme::Warning
end

xeme.note() do |child|
  puts child.class # => Xeme::Note
end

xeme.promise() do |child|
  puts child.class # => Xeme::Promise
end
## {"end":"all"}


# done
puts '[done]'