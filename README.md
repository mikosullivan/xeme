# Xeme

Xeme provides a common format for returning the results of a process. First
we'll look at the Xeme format, which is language independent, then we'll look at
how the Xeme gem implements the format.


## Xeme structure

The Xeme structure can be used by any software, Ruby or otherwise, as a standard
way to report results. A Xeme structure can be stored in any format that
recognizes hashes, arrays, strings, numbers, booleans, and null. Such formats
include JSON and YAML. In these examples we'll use JSON.

A xeme can be as simple as an empty hash:

```json
{}
```

That structure indicates no errors, and, in fact, no details at all. However, it
also does not explicitly indicate success, so that xeme would be considered to
have failed.

To indicate a successful operation, a xeme must have an explicit `success`
element:

```json
{"success":true}
```

A xeme can be marked as explicitly failed:

```json
{"success":false}
```

If a xeme does not have an explicit `success` element, or it is set to `nil`, it
should be considered to have failed. However, depending on how you process the
xeme, `nil` could be considered as having not finished the test. In that case,
consider using [promises](#promises).

### Messages

A message is an error, a warning, a note, or a promise. Each type of message has
an array. For example, this xeme has two errors:

```json
{ "errors":[{"id":"http-fault"}, {"id":"transaction-error"}] }
```

A message does not have to have any particular structure, but best practice is
to give each message an identifier (`id`).

If there are any errors then that indicates a failure, regardless of the value
of `success`. Any implementation of Xeme should have a method for resolving
conflicts between `success` and `errors`, always giving priority to the presence
of errors over the value of `success`.

If a xeme has any promises then that indicates not success, though not
necessarily explicit failure. If a xeme is marked as successful, but there are
promises, then `success` should be considered nil.

Warnings indicate problems that don't outright cause a failure. Notes are
messages that don't indicate a problem of any kind.

### Metainformation

Sometimes it's useful to store metainformation the xeme. For example, log files
are more discoverable if each xeme has a unique id and timestamp. Generally a
xeme will have at least to elements, `uuid` and `timestamp`:

```json
{
   "meta":{
      "uuid":"dae1cf26-e8fa-43fa-bedc-88fea10255f4",
      "timestamp":"2023-05-25 03:46:19 -0400"
   }
}
```

### Nested xemes

A xeme can have nested xemes within it. Those nested xemes go in the `nested`
array:

```json
{
   "nested": [
      { "success": true },
      { "errors": [{"id":"server-fault"}] },
   ]
}
```

For a xeme to be considered successful, all of its nested xemes must be marked
as success. If any nested xemes have errors, then the outermost xeme is
considered to be considered as failed. If any nested xemes has `success` as nil,
then the outermost xeme cannot `success` as true, though it can be explicitly
false.

## Xeme gem

### Install

The usual:

```sh
gem install xeme
```

### Basic Xeme concepts

Xeme (the gem) is a thin layer over a hash that implements the Xeme format. (For
the rest of this document "Xeme" refers to the Ruby class, not the format.)
Create a new xeme by instantiating the Xeme class. Instantiation has no required
parameters.

```ruby
require 'xeme'
xeme = Xeme.new
puts xeme # => #<Xeme:0x000055586f1340a8>
```

Sometimes it's handy to give a xeme an identifier. You can do that by passing in
a string in `Xeme.new`.

```ruby
xeme = Xeme.new('my-xeme')
puts xeme.id # => my-xeme
```

If you want to access the hash stored in the xeme object, you can use the object
as if it were a hash.

```ruby
xeme['errors'] = []
xeme['errors'].push({'id'=>'my-error'})
```

### Success and failure

Because a xeme isn't considered successful until it has been explicitly declared
so, a new xeme is considered to indicate failure. However, because there are no
errors and `success` has not been explicitly set, `success?` returns `nil`
instead of `false`.

```ruby
xeme = Xeme.new
puts xeme.success?.class # => NilClas
```

There are two ways to mark a xeme as successful, one of which usually the better
choice. The not-so-good way to mark success is with the `succeed` method.

```ruby
xeme = Xeme.new
xeme.succeed
puts xeme.success?  # => true
```

The problem with `succeed` is that if there are errors, `succeed` will raise an
exception.

```ruby
xeme = Xeme.new
xeme.error 'my-error'
xeme.succeed # => raises exception: `succeed': cannot-set-to-success: errors
```

A better option is `try_succeed`. If your script gets to a point, usually at the
end of the function or script, that you want to set the xeme to success, but
only if there are no errors, use `try_succeed`.

```ruby
xeme = Xeme.new
xeme.try_succeed
puts xeme.success? # => true
```

If there are errors, `try_succeed` won't raise an exception, but will not set
the xeme to failure.

```ruby
xeme = Xeme.new
xeme.error 'my-error'
xeme.try_succeed
puts xeme.success? # => false
```

### Creating and using messages

Messages in a xeme provide a way to indicate errors (i.e. fatal errors),
warnings (non-fatal errors), notes (not an error at all), and promises (guides
to getting the final success or failure of the process). A message is a hash
with whatever arbitrary information you want to add. Each type of message has
its own method for creating it, an array for storing them, and methods for
checking if any exist. The following script creates an error, a warning, a
note, and a promise.

```ruby
xeme = Xeme.new
xeme.error 'my-error'
xeme.warning 'my-warning'
xeme.note 'my-note'
xeme.promise 'my-promise'
```

`#error`, `#warning`, `#note`, and `#promise` each create a message for their
own type. Although it is not required, it's usually a good idea to give a string
as the first parameter. That string will be set to the `id` element in the
resulting hash, as seen in the example above.

`#errors`, `#warnings`, `#notes`, and `#promises` return arrays for each type.

```ruby
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
```

**Gotcha:** These methods return frozen arrays, *not* the arrays in the xeme.
This is because these methods return not only the xeme's own message arrays, but
also any nested messages. See [Nesting xemes](#nesting-xemes) below.

There are several ways to create and populate a message. Choose whichever is
preferable to you. One way is demonstrated in the example above. You simply call
the appropriate method, passing in an identifier. If all you want to do is
create a message with an `id` then that's probably the easiest choice.

Another way to use a `do` block to add custom information to the message.

```ruby
xeme.error('my-error') do |error|
   error['database-error'] = 'some database error'
   error['commands'] = ['a', 'b', 'c']
end
```

Remember a message is just a hash, so you can add any kind of structure to the
hash you want such a strings, booleans, hashes, and arrays.

Finally, the message command returns the new message. So, if you want, you can
assign that return value to a variable and work with the message that way.

```ruby
err = xeme.error('my-error')
err['database-error'] = 'some database error'
err['commands'] = ['a', 'b', 'c']
```

### Creating metainformation

The `#meta` method returns the `meta` element in the xeme hash, creating it if
necessary. The hash will be automatically populated with a timestamp and a UUID.
If you gave the xeme an identifier when you created it, that id will stored in
the meta hash:

```ruby
xeme = Xeme.new('my-xeme')
puts xeme.meta
```

This produces a `meta` hash like this:

```ruby
{
   "uuid"=>"4e736a8f-314e-470a-8209-6811a7b2d38c",
   "timestamp"=>2023-05-29 19:22:37.26152866 -0400,
   "id"=>"my-xeme"
}
```

If you don't pass in an id then the meta hash isn't created. However, you can
always create and use the meta hash by calling the `#meta` method. The timestamp
and UUID will be automatically created.

```ruby
xeme = Xeme.new
xeme.meta['foo'] = 'bar'
xeme.meta.class # => Hash
```

### Nesting xemes

In complex testing situations it can be useful to nest results within other
results. To nest a xeme within another xeme, use the `#nest` method:

```ruby
xeme = Xeme.new('results')
xeme.nest 'child-xeme'
```

You probably want to do something more than just create a nested xeme, so you
can use a `do` block to work with the nested xeme:

```ruby
xeme.nest('child-xeme') do |child|
   child.error 'child-error'
end
```

You can loop through all xemes, including the outermost xeme and all nested
xemes, using the `#all` method.

```ruby
xeme.all.each do |x|
   puts x.id
end
```

**Nested messages**

The `#errors`, `#warnings`, `#notes`, and `#promises` methods return arrays of
all messages within the xeme, including the outermost xeme and nested xemes.

```ruby
xeme = Xeme.new
xeme.error 'outer-error'

xeme.nest do |child|
   child.error 'child-error'
end

puts xeme.errors

# => {"id"=>"outer-error"}
# => {"id"=>"child-error"}
```

If you want to search for messages with a specific `id`, add that id to the
messages method:

```ruby
puts xeme.errors('child-error') # => {"id"=>"child-error"}
```

**Flatten**

Finally, if you want to slurp up all messages into the outermost xeme and delete
the nested xemes, use `#flatten`.

```ruby
puts xeme['errors']
# => {"id"=>"outer-error"}

xeme.flatten

puts xeme['errors']
# => {"id"=>"outer-error"}
# => {"id"=>"child-error"}
```


### Resolving xemes

A xeme can contain contradictory information. For example, if `success` is true
but there are errors, then the xeme should be considered as failed. If there are
promises, then the xeme should not be considered as failed, although `success`
may be set as nil.

The `#resolve` method resolves those contradictions. Generally you won't have to
call `#resolve` yourself, but it's worth understanding the rules:

* A xeme can always be explicitly set to false, regardless of any other
considerations. Resolution never changes a `success` of false.

* If any nested xemes have `success` explicitly set to false, then the outermost
xeme will be set to false.

* If a xeme has errors, or any of it's nested xemes has errors, then it is set
to false.

* If a xeme has promises, or any of its nested xemes do, then it cannot be set
to true. If it is already false, then it stays false. Otherwise `success` is set
to nil.

* If any nested xemes have `success` set to nil, then the outermost xeme cannot
be set to true.

## The name

The word "xeme" has no particular association with the concept of results
reporting. I got the word from a random word generator and I liked it. The xeme,
also known as Sabine's gull, is a type of gull. See
[the Wikipedia page](https://en.wikipedia.org/wiki/Sabine's_gull)
if you'd like to know more.

## Author

Mike O'Sullivan
mike@idocs.com

## History

| version | date         | notes                         |
|---------|--------------|-------------------------------|
| 0.1     | Jan 7, 2020  | Initial upload.               |
| 1.0     | May 29, 2023 | Complete overhaul. Not backward compatible. |