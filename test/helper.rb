require 'xeme'
require 'timecop'

# nested structure
module Xeme::Nester
  def self.create(level=0)
    # create xeme
    xeme = Xeme.new
    
    # nest subclasses
    xeme.error
    xeme.success
    xeme.warning
    xeme.note
    xeme.promise
    
    # add nested xemes
    if level <= 3
      3.times do
        xeme.nest create(level+1)
      end
    end
    
    # return
    return xeme
  end
end

def json_file(path)
  dir = File.dirname(caller_locations.first.path)
  abs_path = File.expand_path(path, dir)
  return JSON.parse( File.read(abs_path) )
end

def local_file(path)
  dir = File.dirname(caller_locations.first.path)
  abs_path = File.expand_path(path, dir)
  return File.read(abs_path)
end