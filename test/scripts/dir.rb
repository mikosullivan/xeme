$LOAD_PATH.unshift File.expand_path('../../lib', File.dirname(__FILE__))
require 'bryton/lite.rb'
require 'json'
require 'local-json'
require 'declutter'
require 'xeme'
require 'tatum'
TTM.io = STDERR

# nester_max
def nester_max(multiplier=1)
  return 10 * multiplier
end

# nester
# Creates a xeme with nine nested xemes.
def nester
  # steps
  steps = (1..nester_max()).to_a
  
  # top xeme
  xeme = Xeme.new
  current = xeme
  
  # populate and nest xemes
  steps.each do |idx|
    if block_given?
      yield current
    end
    
    unless idx == steps.max
      current = current.nest
    end
  end
  
  # return
  return xeme
end

# food_tree
def food_tree
  require_relative './food.rb'
  return create_food_tree()
end