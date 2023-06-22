require 'deep_dup'
require 'forwardable'
# require 'declutter'
require 'json'
require 'date'

#===============================================================================
# Xeme
#

# An object of the Xeme class represents a single xeme.
# 
# Documentation frequently refers to `@hsh`, which is a private object used to
# store the xeme information.

class Xeme
  
  # Version.
  VERSION = '2.0'
  
  # Default value for `@hsh`. Xeme defaults to an empty hash. Subclasses of Xeme
  # set their own defaults.
  DEFAULT = {}.freeze
  
  # An array of keys for `@hsh` that cannot be set.
  PROHIBIT_ASSIGN = ['type'].freeze
  
  # Indicates if the xeme is advisory.
  ADVISORY = false
  
  # A list of xeme types and their associated classes. Xeme subclasses populate
  # this property.
  TYPES = {}
  
  # delegate
  extend Forwardable
  delegate %w([] each length keys value empty? any? has_key? to_json) => :@hsh
  
  
  #-----------------------------------------------------------------------------
  # initialize
  #
  
  # Initializes a new xeme. The single optional param can be nil, a hash that
  # will be imported into the `@hsh` element, or a JSON string that will be
  # parsed into a hash for the @hsh element.
  
  def initialize(p_hsh=nil)
    # initialize @hsh
    @hsh = DeepDup.deep_dup(self.class::DEFAULT)
    
    # merge in given hash if one was sent
    if p_hsh
      if p_hsh.is_a?(String)
        p_hsh = JSON.parse(p_hsh)
      end
      
      @hsh = @hsh.merge(p_hsh)
    end
    
    # import nested
    if @hsh['nested']
      raws = @hsh.delete('nested')
      @hsh['nested'] = []
      
      raws.each do |raw|
        @hsh['nested'].push Xeme.import(raw)
      end
    end
  end
  #
  # initialize
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # success?
  #
  
  # Resolves the xeme, then returns the value of `@hsh['success']`.
  # @return (Boolean)
  def success?
    resolve
    return @hsh['success']
  end
  
  #
  # success?
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # []=
  #
  
  # Sets values in `@hsh`. Specific Xeme classes can prohibit the setting of
  # specific keys in the hash. `type` is always prohibited. Advisory xemes also
  # prohibit directly setting `success`.
  # @raise (Xeme::Exception::CannotAssignKey)
  def []=(k, v)
    # prohibit keys in PROHIBIT_ASSIGN
    if self.class::PROHIBIT_ASSIGN.include?(k)
      raise Xeme::Exception::CannotAssignKey.new(k)
    end
    
    # allow assignment
    @hsh[k] = v
  end
  
  # Deletes values in @hsh. Specific Xeme classes can prohibit the deletion of
  # specific keys in the hash. "type" is always prohibited. Advisory xemes also
  # prohibit deleting `success`.
  # @raise (Xeme::Exception::CannotDeleteKey)
  def delete(k)
    # prohibit keys in PROHIBIT_ASSIGN
    if self.class::PROHIBIT_ASSIGN.include?(k)
      raise Xeme::Exception::CannotDeleteKey.new(k)
    end
    
    # allow assignment
    return @hsh.delete(k)
  end
  
  #
  # []=
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # nested, misc
  #
  
  # Creates `@hsh['nested']` if necessary and returns it.
  # @return (Array)
  def nested
    @hsh['nested'] ||= []
    return @hsh['nested']
  end
  
  # A handy place to put miscellaneous information. No Xeme methods use this
  # hash.
  # @return (Hash)
  def misc
    @hsh['misc'] ||= {}
    return @hsh['misc']
  end
  
  #
  # nested, misc
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # meta
  #
  
  # Creates `@hsh['meta']` if it does not already exist, then returns it.
  # @return (Hash)
  def meta
    return @hsh['meta'] ||= {}
  end
  
  # Creates `@hsh['meta']['uuid']` if it does not already exist, then returns
  # it.
  # @return (String)
  def init_uuid
    if not meta['uuid']
      require 'securerandom'
      meta['uuid'] ||= SecureRandom.uuid
    end
    
    return meta['uuid']
  end
  
  # Creates `@hsh['meta']['timestamp']` if it doesn't already exist.
  # @return (DateTime)
  def init_timestamp
    meta['timestamp'] ||= DateTime.now
    return meta['timestamp']
  end
  
  # Initializes `@hsh['meta']` if it doesn't already exist. Also initializes
  # `@hsh['meta']['timestamp']` and `@hsh['meta']['uuid']` if they don't already
  # exist.
  # @return (Hash)
  def init_meta
    init_timestamp()
    init_uuid()
    return @hsh['meta']
  end
  
  # Returns `@hsh['meta']['timestamp']`. Does not initialize it if it doesn't
  # exist.
  # @return (DateTime)
  def timestamp
    if @hsh['meta']
      return @hsh['meta']['timestamp']
    else
      return nil
    end
  end
  
  # Returns `@hsh['meta']['uuid']`. Does not initialize it if it doesn't
  # exist.
  # @return (String)
  def uuid
    if @hsh['meta']
      return @hsh['meta']['uuid']
    else
      return nil
    end
  end
  
  # Sets the value of `@hsh['meta']['id']`.
  def id=(v)
    return meta['id'] = v
  end
  
  # Returns the value of `@hsh['meta']['id']`.
  def id()
    return meta['id']
  end
  #
  # meta
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # all, errors, successes, warnings, notes, promises
  #
  
  # Returns a locked array of the xeme and all of its nested xemes.
  # @param clss [Class] optional param of which class of xemes to return.
  # @return [Array]
  def all(clss=Xeme)
    # initialize return value
    rv = []
    
    # add self if right class
    if self.is_a?(clss)
      rv << self
    end
    
    # add nested xemes
    if @hsh['nested']
      @hsh['nested'].each do |child|
        rv += child.all(clss)
      end
    end
    
    # freeze and return
    rv.freeze
    return rv
  end
  
  # Returns a locked array of all warning xemes.
  # @return [Array]
  def warnings
    return all(Warning)
  end
  
  # Returns a locked array of all note xemes.
  # @return [Array]
  def notes
    return all(Note)
  end
  
  # Returns a locked array of all advisory (warning and note) xemes.
  # @return [Array]
  def advisories
    return all(Advisory)
  end
  
  # Returns a locked array of all promise xemes.
  # @return [Array]
  def promises
    return all(Promise)
  end
  
  # Returns a locked array of all xemes with an explicit setting of
  # success=false.
  # @return [Array]
  def errors
    return select {|x| x['success'].is_a?(FalseClass)}
  end
  
  # Returns a locked array of all xemes with an explicit setting of
  # success=true.
  # @return [Array]
  def successes
    return select {|x| x['success']}
  end
  
  # Returns a locked array of all xemes in which success is nil. Does not return
  # advisory xemes.
  # @return [Array]
  def nils
    return select {|x| (not x.advisory?) and x['success'].nil?}
  end
  
  #
  # all
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # nest
  #
  
  # Creates or accepts a xeme and nests it.
  # @return (Xeme)
  # @yield (Xeme)
  # @raise (Xeme::Exception::InvalidNestClass)
  # @raise (Xeme::Exception::InvalidNestType)
  # @raise (Xeme::Exception::CannotNestNonadvisory)
  def nest(type=nil)
    # determine which type of Xeme to use. type can be a Xeme class or a xeme.
    if type.nil?
      child = self.class.new
    elsif type.is_a?(Class)
      if type <= Xeme
        child = type.new
      else
        raise Xeme::Exception::InvalidNestClass.new(type)
      end
    elsif type.is_a?(Xeme)
      child = type
    else
      raise Xeme::Exception::InvalidNestType.new(type)
    end
    
    # advisory cannot nest non-advisory
    if advisory? and (not child.advisory?)
      raise Xeme::Exception::CannotNestNonadvisory.new(child.class)
    end
    
    # add child to nested array
    nested.push child
    
    # yield if necessary
    if block_given?
      yield child
    end
    
    # return child
    return child
  end
  
  #
  # nest
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # nesting types
  #
  
  # Adds a nested xeme that is automatically set as failed. Also sets the
  # calling xeme to failure, because if a nested xeme is set to failure than the
  # parent xeme must be set to failure.
  # @return [Xeme]
  # @yield [Xeme]
  def error(&block)
    fail
    child = Xeme.new()
    child.fail
    return nest(child, &block)
  end
  
  alias_method :failure, :error
  
  # Adds a nested xeme that is automatically set as successful.
  # @return [Xeme]
  # @yield [Xeme]
  def success(&block)
    child = Xeme.new()
    child.try_succeed
    return nest(child, &block)
  end
  
  # Adds a nested Warning xeme.
  # @return [Xeme::Warning]
  # @yield [Xeme::Warning]
  def warning(&block)
    return nest(Xeme::Warning.new, &block)
  end
  
  # Adds a nested Note xeme.
  # @return [Xeme::Note]
  # @yield [Xeme::Note]
  def note(&block)
    return nest(Xeme::Note.new, &block)
  end
  
  # Adds a nested Promise xeme.
  # @return [Xeme::Promise]
  # @yield [Xeme::Promise]
  def promise(&block)
    unless @hsh['success'].is_a?(FalseClass)
      @hsh.delete 'success'
    end
    
    return nest(Xeme::Promise.new, &block)
  end
  #
  # nesting types
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # fail, undecide, try_succeed
  #
  
  # Sets `success` to `false`.
  # @return [Boolean] `false`
  def fail
    return self['success'] = false
  end
  
  # Deletes the `success` element.
  # @return [Boolean] `nil`
  def undecide
    @hsh.delete 'success'
    return nil
  end
  
  # Resolves the xeme and all descendents, then tries to set it to successful.
  # Will only set to success if the xeme (and all descendents) has its `success`
  # element to `nil` or `true`. Will not override `false` if `success` is
  # already set to that value.
  # @return [Boolean] The value of `success`.
  def try_succeed
    return resolve(true)
  end
  
  #
  # fail, undecide, try_succeed
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # resolve
  #
  
  # Resolves the xeme including all nested xemes.
  # @return (Boolean) value of `@hsh['success']`
  # @param p_try_succeed [Boolean] if the method should also try to succeed the
  # xeme.
  def resolve(p_try_succeed=false)
    # if this is just an advisory xeme, do nothing
    if advisory?
      return
    end
    
    # If trying to and allowed to succeed, set success here. Resolution will
    # change success if necessary.
    if allow_try_succeed?(p_try_succeed)
      @hsh['success'] = true
    end
    
    # loop through nested children
    if @hsh['nested']
      @hsh['nested'].each do |child|
        unless child.advisory?
          child.resolve p_try_succeed
          
          # if this xeme isn't already explicitly set to false, downgrade as
          # necessary from child xeme
          unless @hsh['success'].is_a?(FalseClass)
            if child['success'].nil?
              @hsh.delete 'success'
            elsif not child['success']
              @hsh['success'] = false
            end
          end
        end
      end
    end
    
    # return
    return @hsh['success']
  end
  
  #
  # resolve
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # convenience accessors
  #
  
  # Indicates if the xeme is advisory.
  # @return [Boolean]
  def advisory?
    return self.class::ADVISORY
  end
  
  #
  # convenience accessors
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # extended classes
  #
  
  # Base class for Note and Warning. Directly instantiating this class is not
  # advised.
  class Advisory < self
    DEFAULT = {'type'=>'advisory'}.freeze
    PROHIBIT_ASSIGN = ['success', 'type'].freeze
    ADVISORY = true
    Xeme::TYPES['advisory'] = self
  end
  
  # Represents a note xeme.
  class Note < Advisory
    DEFAULT = {'type'=>'note'}.freeze
    Xeme::TYPES['note'] = self
  end
  
  # Represents a warning xeme.
  class Warning < Advisory
    DEFAULT = {'type'=>'warning'}.freeze
    Xeme::TYPES['warning'] = self
  end
  
  # Represents a promise xeme.
  class Promise < self
    DEFAULT = {'type'=>'promise'}.freeze
    PROHIBIT_ASSIGN = ['type'].freeze
    Xeme::TYPES['promise'] = self
    
    # Sets values in `@hsh`. Does not allow setting `success` to true if
    # `supplanted` is not set to true.
    # @raise (Xeme::Exception::CannotSucceedPromiseUnlessSupplanted)
    def []=(k, v)
      if v and (k=='success') and (not @hsh['supplanted'])
        raise Xeme::Exception::CannotSucceedPromiseUnlessSupplanted.new
      end
      
      return super(k, v)
    end
    
    # Resolves the xeme.
    # @param p_try_succeed (Boolean). Meaningless if `supplanted` is not true.
    # @return (Boolean)
    def resolve(p_try_succeed=false)
      super p_try_succeed
      
      if not @hsh['supplanted']
        @hsh.delete 'success'
      end
      
      return @hsh['success']
    end
  end
  #
  # extended classes
  #-----------------------------------------------------------------------------
  
  
  ### class methods
  
  
  #-----------------------------------------------------------------------------
  # import
  #
  
  # Imports a hash or JSON string into a xeme, including nested xemes. The
  # `type` value, if present, is used to determine the class of the xeme.
  
  def self.import(org)
    # parse JSON if necessary
    if org.is_a?(String)
      org = JSON.parse(org)
    end
    
    # if a type is indicated and recognized, instantiate based on that type,
    # else instantiate as Xeme.
    if clss = Xeme::TYPES[org['type']]
      xeme = clss.new(org)
    else
      xeme = self.new(org)
    end
    
    # convert timestamp if it is present
    if xeme['meta'] and xeme['meta']['timestamp']
      xeme['meta']['timestamp'] = DateTime.parse(xeme['meta']['timestamp'])
    end
    
    # return
    return xeme
  end
  #
  # import
  #-----------------------------------------------------------------------------
  
  
  # private
  private
  
  
  #-----------------------------------------------------------------------------
  # allow_try_succeed?
  #
  def allow_try_succeed?(p_try_succeed)
    p_try_succeed or return false
    advisory? and return false
    @hsh['success'].nil? or return false
    return true
  end
  #
  # allow_try_succeed?
  #-----------------------------------------------------------------------------
  
  
  #-----------------------------------------------------------------------------
  # select
  #
  def select()
    resolve
    rv = all.select{|x| yield(x)}
    rv.freeze
    return rv
  end
  #
  # select
  #-----------------------------------------------------------------------------
end
#
# Xeme
#===============================================================================


#===============================================================================
# Xeme::Exception
#

# Base class for Xeme-specific exceptions. Each Xeme-specific exception is
# raised in only one place.
class Xeme::Exception < StandardError
  
  # A human readable string representing the exception.
  KEY = 'exception'
  
  # Holds a detail about the exception. Usually holds an invalid value that
  # triggered the exception.
  attr_reader :detail
  
  def initialize(p_detail=nil)
    @detail = p_detail
  end
  
  # Returns a human readable representation of the exception, including
  # `detail` if provided.
  def message
    rv = self.class::KEY
    
    if @detail
      rv += ': ' + @detail.to_s
    end
    
    return rv
  end
  
  # Raised when a element in `@hsh` cannot be set directly.
  class CannotAssignKey < self
    KEY = 'cannot-assign-to-key'
  end
  
  # Raised when a element in `@hsh` cannot be directly deleted.
  class CannotDeleteKey < self
    KEY = 'cannot-assign-to-key'
  end
  
  # Raised when a xeme will not allow a specific class of xeme to be nested in
  # itself.
  class InvalidNestClass < self
    KEY = 'invalid-nest-class'
  end
  
  # Raised when a xeme will not allow a specific type of xeme to be nested in
  # itself.
  class InvalidNestType < self
    KEY = 'invalid-nest-type'
  end
  
  # Raised when an attempt is made to nest a non-advisory xeme in an advisory
  # xeme.
  class CannotNestNonadvisory < self
    KEY = 'cannot-nest-non-advisory-in-advisory'
  end
  
  # Raised when an attempt is made to mark a promise as successful when the
  # `supplanted` value is not true.
  class CannotSucceedPromiseUnlessSupplanted < self
    KEY = 'cannot-succeed-promise-unless-supplanted'
  end
end
#
# Xeme::Exception
#===============================================================================