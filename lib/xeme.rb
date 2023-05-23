require 'forwardable'
require 'declutter'


#===============================================================================
# Xeme
#
class Xeme
	attr_reader :hsh
	
	#---------------------------------------------------------------------------
	# delegate
	#
	extend Forwardable
	delegate %w([] []= each length clear) => :hsh
	#
	# delegate
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# initialize
	#
	def initialize
		@hsh = {}
	end
	#
	# initialize
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# meta
	#
	def meta
		# TTM.hrm
		require 'securerandom'
		
		# initialize meta element if necessary
		@hsh['meta'] ||= {}
		
		# populate meta
		@hsh['meta']['uuid'] ||= SecureRandom.uuid().to_s
		@hsh['meta']['timestamp'] ||= Time.now
		
		# return
		return @hsh['meta']
	end
	
	def uuid
		return meta['uuid']
	end
	
	def timestamp
		return meta['timestamp']
	end
	
	def id
		return meta['id']
	end
	
	def id=(v)
		return meta['id'] = v
	end
	#
	# meta
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# succeed
	#
	
	# Attempt to set success to true. Raises an exception if there are any
	# errors in this or any nested Xeme.
	
	def succeed
		if @hsh['errors'] and @hsh['errors'].any?
			raise 'cannot-set-to-success: errors'
		elsif not nested_success?()
			raise 'cannot-set-to-success: nested fail'
		else
			return @hsh['success'] = true
		end
	end
	#
	# succeed
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# fail
	#
	
	# Explicitly set success to false. Does not add an error.
	
	def fail
		@hsh['success'] = false
	end
	
	#
	# fail
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# success?
	#
	def success?
		if @hsh['success'] and nested_success?()
			return true
		else
			return false
		end
	end
	#
	# success?
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# failure?
	#
	def failure?
		return !success?
	end
	#
	# failure?
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# add message
	#
	def error(id=nil, &block)
		return message('errors', id, &block)
	end
	
	def warning(id=nil, &block)
		return message('warnings', id, &block)
	end
	
	def note(id=nil, &block)
		return message('notes', id, &block)
	end
	#
	# add message
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# messages
	#
	def errors
		return messages('errors')
	end
	
	def warnings
		return messages('warnings')
	end
	
	def notes
		return messages('notes')
	end
	#
	# messages
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# messages?
	#
	def errors?
		return messages?('errors')
	end
	
	def warnings?
		return messages?('warnings')
	end
	
	def notes?
		return messages?('notes')
	end
	#
	# messages?
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# nest
	#
	def nest
		@hsh['nested'] ||= []
		@hsh['nested'].push self.class.new()
		
		if block_given?
			yield @hsh['nested'][-1]
		end
	end
	#
	# nest
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# nested
	#
	def nested
		@hsh['nested'] ||= []
		return @hsh['nested']
	end
	#
	# nest
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# resolve
	#
	def resolve
		# resolve self
		if errors? or (not nested_success?)
			@hsh['success'] = false
		end
		
		# resolve nested
		if @hsh['nested']
			@hsh['nested'].each do |child|
				child.resolve
			end
		end
		
		# declutter
		declutter()
	end
	#
	# resolve
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# declutter
	#
	def declutter
		Declutter.process @hsh
	end
	#
	# declutter
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# all
	#
	
	# Returns an array consisting of the xeme and all nested xemes.
	
	def all
		rv = [self]
		
		if @hsh['nested']
			@hsh['nested'].each do |child|
				rv += child.all
			end
		end
		
		# return
		return rv
	end
	#
	# all
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# all_[message]s
	#
	def all_errors
		return all_messages('errors')
	end
	
	def all_warnings
		return all_messages('warnings')
	end
	
	def all_notes
		return all_messages('notes')
	end
	#
	# all_[message]s
	#---------------------------------------------------------------------------
	
	
	# private
	private
	
	
	#---------------------------------------------------------------------------
	# messages
	#
	def messages(type)
		@hsh[type] ||= []
		return @hsh[type]
	end
	#
	# messages
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# message
	#
	def message(type, id=nil, &block)
		# build message
		msg = {}
		id and msg['id'] = id
		
		# add to array
		@hsh[type] ||= []
		@hsh[type].push msg
		
		# yield if necessary
		if block_given?
			yield msg
		end
		
		# return
		return msg
	end
	#
	# message
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# messages?
	#
	def messages?(type, id=nil, &block)
		# if messages in this xeme
		if @hsh[type] and @hsh[type].any?
			return true
		end
		
		# check nested
		if @hsh['nested']
			@hsh['nested'].each do |child|
				if child.send("#{type}?")
					return true
				end
			end
		end
		
		# if we get this far then no messages of given type
		return false
	end
	#
	# messages?
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# nested_success?
	#
	def nested_success?
		if @hsh['nested']
			@hsh['nested'].each do |child|
				if not child.success?
					return false
				end
			end
		end
		
		# if we get this far then allow success
		return true
	end
	#
	# nested_success?
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# all_messages
	#
	def all_messages(plural)
		rv = []
		
		# add own messages
		if @hsh[plural]
			rv += @hsh[plural]
		end
		
		# recurse
		if @hsh['nested']
			@hsh['nested'].each do |child|
				rv += child.send("all_#{plural}")
			end
		end
		
		# return
		return rv
	end
	#
	# all_messages
	#---------------------------------------------------------------------------
end
#
# Xeme
#===============================================================================