#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'xeme'

## {"start":"create"}
xeme = Xeme.new
xeme.error 'my-error'
xeme.warning 'my-warning'
xeme.note 'my-note'
xeme.promise 'my-promise'
## {"end":"create"}

TTM.hr

## {"start":"ids"}
xeme.errors.each do |e|
	puts e['id'] # => my-error
end

xeme.warnings.each do |w|
	puts w['id'] # => my-warning
end

xeme.notes.each do |n|
	puts n['id'] # => my-note
end

xeme.promises.each do |p|
	puts p['id'] # => my-promise
end
## {"end":"ids"}


# done
puts '[done]'