require 'forwardable'
require 'declutter'


#===============================================================================
# Xeme
#
class Xeme
	# Returns the underlying hash that the xeme manages.
	attr_reader :hsh
	
	#---------------------------------------------------------------------------
	# delegate
	#
	extend Forwardable
	delegate %w([] []= each length clear delete to_json) => :hsh
	#
	# delegate
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# initialize
	#
	
	# Creates a new Xeme object. Optionally takes a single strin parameter which
	# is set as the id for the xeme.
	
	def initialize(id=nil)
		@hsh = {}
		
		if id
			meta id
		end
	end
	#
	# initialize
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# meta
	#
	
	# Returns the meta hash, creating it if necessary. The meta hash
	# contains at least a timestamp and a UUID.
	
	def meta(id=nil)
		require 'securerandom'
		
		# initialize meta element if necessary
		@hsh['meta'] ||= {}
		
		# populate meta
		@hsh['meta']['uuid'] ||= SecureRandom.uuid().to_s
		@hsh['meta']['timestamp'] ||= Time.now
		
		# give child id if given
		if id
			meta['id'] = id
		end
		
		# return
		return @hsh['meta']
	end
	
	# Returns the UUID in the meta hash.
	def uuid
		return meta['uuid']
	end
	
	# Returns the timestamp in the meta hash.
	def timestamp
		return meta['timestamp']
	end
	
	# Returns the id element of the meta hash if there is one.
	def id
		if @hsh['meta']
			return @hsh['meta']['id']
		else
			return nil
		end
	end
	
	# Sets id element of the meta.
	def id=(v)
		return meta['id'] = v
	end
	#
	# meta
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# flatten
	#
	
	# Folds all nested messages into the outermost xeme, and deletes nested
	# xemes. Only the messages are folded in, not any metainformation or other
	# information that might be in the nested xemes.
	
	def flatten
		resolve()
		
		as_arr('nested').each do |child|
			child.flatten
			
			%w{errors warnings notes promises}.each do |msg_key|
				if child[msg_key]
					@hsh[msg_key] ||= []
					@hsh[msg_key] += child[msg_key]
					child.delete(msg_key)
				end
			end
		end
		
		@hsh.delete('nested')
	end
	#
	# flatten
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# to_h
	#
	# def to_h
	# 	rv = @hsh.to_h
	# 	
	# 	# loop through nested xemes
	# 	if rv['nested']
	# 		rv['nested'] = rv['nested'].map do |child|
	# 			child.to_h
	# 		end
	# 	end
	# 	
	# 	# return
	# 	return rv
	# end
	#
	# to_h
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# succeed
	#
	
	# Attempt to set success to true. Raises an exception if there are any
	# errors or promises in this or any nested Xeme.
	
	def succeed
		# if any errors, don't succeed
		if errors.any?
			raise 'cannot-set-to-success: errors'
		end
		
		# if any promises, don't succeed
		if promises.any?
			raise 'cannot-set-to-success: promises'
		end
		
		# set to success
		return @hsh['success'] = true
	end
	
	#
	# succeed
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# try_succeed
	#
	
	# Attempt to set success to true. Does not raise an exception if there are
	# errors or promises, but in those cases will not set success to true.
	
	def try_succeed(resolve_self=true)
		enforce_nil = false
		
		# resolve self and descendents
		if resolve_self
			resolve()
		end
		
		# if any promises
		if as_arr('promises').any?
			@hsh.delete 'success'
			enforce_nil = true
		end
		
		# try_succeed for descendents
		as_arr('nested').each do |child|
			child.try_succeed false
			
			if @hsh['success'].nil?
				if child['success'].nil?
					enforce_nil = true
				elsif not child['success']
					@hsh['success'] = false
				end
			end
		end
		
		# set to success if success is nil and no promises
		if @hsh['success'].nil? and (! enforce_nil)
			@hsh['success'] = true
		end
		
		# return
		return @hsh['success']
	end
	
	#
	# try_succeed
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# fail
	#
	
	# Explicitly set success to false. Does not add an error.
	
	def fail
		@hsh['success'] = false
		resolve()
	end
	
	#
	# fail
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# success?
	#
	def success?
		resolve()
		return @hsh['success']
	end
	#
	# success?
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# messages
	#
	
	# Returns a locked array of all errors, including errors in nested xemes.
	# If the optional id param is sent, returns only errors with that id.
	def errors(id=nil)
		return all_messages('errors', id)
	end
	
	# Returns a locked array of all warnings, including warnings in nested xemes.
	# If the optional id param is sent, returns only warnings with that id.
	def warnings(id=nil)
		return all_messages('warnings', id)
	end
	
	# Returns a locked array of all notes, including notes in nested xemes.
	# If the optional id param is sent, returns only notes with that id.
	def notes(id=nil)
		return all_messages('notes', id)
	end
	
	# Returns a locked array of all promises, including promises in nested xemes.
	# If the optional id param is sent, returns only promises with that id.
	def promises(id=nil)
		return all_messages('promises', id)
	end
	
	#
	# messages
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# message hashes
	#
	
	# Returns a hash of all errors, including nested errors. The key for each
	# element is the id of the error(s). Does not return errors that don't have
	# ids.
	def errors_hash()
		return messages_hash('errors')
	end
	
	# Returns a hash of all warnings, including nested warnings. The key for
	# each element is the id of the warnings(s). Does not return warnings that
	# don't have ids.
	def warnings_hash(id=nil)
		return messages_hash('warnings')
	end
	
	# Returns a hash of all notes, including nested notes. The key for each
	# element is the id of the notes(s). Does not return notes that don't have
	# ids.
	def notes_hash(id=nil)
		return messages_hash('notes')
	end
	
	# Returns a hash of all promises, including nested promises. The key for
	# each element is the id of the promise(s). Does not return promises that
	# don't have ids.
	def promises_hash(id=nil)
		return messages_hash('promises')
	end
	
	#
	# message hashes
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# add message
	#
	
	# Creates and returns an error message. Accepts a do block which yields the
	# new message. If given the opional id param, sets that value as the id for
	# the message.
	def error(id, &block)
		@hsh['success'] = false
		return message('errors', id, &block)
	end
	
	# Creates and returns a warning message. Accepts a do block which yields
	# the new message. If given the opional id param, sets that value as the id
	# for the new message.
	def warning(id, &block)
		return message('warnings', id, &block)
	end
	
	# Creates and returns a note message. Accepts a do block which yields
	# the new message. If given the opional id param, sets that value as the id
	# for the new message.
	def note(id, &block)
		return message('notes', id, &block)
	end
	
	# Creates and returns a promise message. Accepts a do block which yields
	# the new message. If given the opional id param, sets that value as the id
	# for the new message.
	def promise(id, &block)
		unless @hsh['success'].is_a?(FalseClass)
			@hsh.delete 'success'
		end
		
		return message('promises', id, &block)
	end
	
	#
	# add message
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# nest
	#
	
	# Creates a new xeme and nests it in the current xeme. Yields to a do block
	# if one is sent. Returns the new child xeme.
	
	def nest(id=nil)
		@hsh['nested'] ||= []
		child = self.class.new()
		@hsh['nested'].push child
		
		# give id
		if id
			child.meta['id'] = id
		end
		
		# yield in block
		if block_given?
			yield child
		end
		
		# return
		return child
	end
	
	#
	# nest
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# nested
	#
	# def nested()
	#	@hsh['nested'] ||= []
	#	return @hsh['nested']
	# end
	#
	# nested
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# resolve
	#
	
	# Resolves conflicts between errors, promises, and success. See README.md
	# for details. You generally don't need to call this method yourself.
	
	def resolve
		# resolve descendents
		as_arr('nested').each do |child|
			child.resolve
		end
		
		# if own errors, fail
		if as_arr('errors').any?
			@hsh['success'] = false
			return
		end
		
		# if explicitly set to false, return
		if @hsh['success'].is_a?(FalseClass)
			return
		end
		
		# if any promises, set success to nil
		if as_arr('promises').any?
			@hsh.delete 'success'
		end
		
		# if any child is set to nil, set self to nil
		# if any child set to false, set self to false and return
		as_arr('nested').each do |child|
			if child['success'].nil?
				@hsh.delete 'success'
			elsif not child['success']
				@hsh['success'] = false
				return
			end
		end
	end
	#
	# resolve
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# declutter
	#
	
	# Removes empty arrays and hahes.
	
	def declutter
		resolve()
		Declutter.process @hsh
		return true
	end
	#
	# declutter
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# all
	#
	
	# Returns an array consisting of the xeme and all nested xemes.
	
	def all(seek_id=nil)
		rv = []
		
		# add self
		if seek_id
			if id == seek_id
				rv.push self
			end
		else
			rv.push self
		end
		
		# loop through nested children
		as_arr('nested').each do |child|
			rv += child.all(seek_id)
		end
		
		# freeze return value
		rv.freeze
		
		# return
		return rv
	end
	#
	# all
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# misc
	#
	
	# A handy place to puts miscellaneous information.
	
	def misc
		@hsh['misc'] ||= {}
		return @hsh['misc']
	end
	
	#
	# misc
	#---------------------------------------------------------------------------
	
	
	# private
	private
	
	
	#---------------------------------------------------------------------------
	# as_arr
	#
	
	# Convenience function for reading messages as arrays even if they don't
	# exist.
	
	def as_arr(key)
		return @hsh[key] || []
	end
	#
	# as_arr
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# message
	#
	
	# Creates a message object of the given type.
	
	def message(type, id, &block)
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
	# all_messages
	#
	
	# Returns a locked array of all messages (including nested) or the given
	# type.
	
	def all_messages(plural, id)
		rv = []
		
		# add own messages
		if @hsh[plural]
			if id
				@hsh[plural].each do |m|
					if m['id'] == id
						rv.push m
					end
				end
			else
				rv += @hsh[plural]
			end
		end
		
		# recurse
		as_arr('nested').each do |child|
			rv += child.send(plural, id)
		end
		
		# freeze return value
		rv.freeze
		
		# return
		return rv
	end
	#
	# all_messages
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# messages_hash
	#
	
	# Returns a hash of the messages (including nested) of the given type. The
	# keys to the hash are the message ids. Does not return messages that don't
	# have ids.
	
	def messages_hash(type)
		rv = {}
		
		# add own messages
		as_arr(type).each do |msg|
			if msg['id']
				rv[msg['id']] ||= []
				rv[msg['id']].push msg
			end
		end
		
		# loop through nested children
		as_arr('nested').each do |child|
			child.send("#{type}_hash").each do |k, msgs|
				rv[k] ||= []
				rv[k] += msgs
			end
		end
		
		# return
		return rv
	end
	#
	# messages_hash
	#---------------------------------------------------------------------------
end
#
# Xeme
#===============================================================================