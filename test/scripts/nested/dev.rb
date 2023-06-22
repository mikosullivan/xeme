#!/usr/bin/ruby -w
require_relative '../../helper.rb'
require 'tatum/stdout'

top = Xeme::Nester.create()
puts top.warnings.length
puts top.notes.length

selected = top.advisories
puts selected.length

classes = {}

selected.each do |xeme|
  classes[xeme.class] = true
end

TTM.show classes.keys


# done
puts '[done]'