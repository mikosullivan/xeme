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
also does not explicitly indicate success. In the absence of a defined value of
true or false, the result should be considered either undetermined or failed.

To indicate a successful operation, a xeme must have an explicit `success`
element:

```json
{"success":true}
```

A xeme can be marked as explicitly failed:

```json
{"success":false}
```

Any truthy value for `success` is considered to indicate success. So, for
example, the following xeme should be considered to indicate success.

```json
{"success":{}}
```

A xeme may contain other arbitrary information. This is useful if you need more
information than just a success or failure.

```json
{"success":true, "tags":["a", "b"]}
```

### Metainformation

A xeme may contain a `meta` element. The `meta` element can contain a timestamp,
UUID, description, or other meta information.

```json
{
  "success":true,
  "meta": {
    "timestamp": "2023-06-21T08:57:56+00:00",
    "uuid": "e11b668c-0823-4b70-aa28-5ac83757a37c",
    "description": "directory tests"
  }
}
```

`meta` can contain any arbitrary information you want, but several elements, if
present, should follow some standards.

| key         | description                                  |
|-------------|----------------------------------------------|
| id          | A string, typically without spaces.          |
| description | A short description of the xeme as a string. |
| timestamp   | Timestamp in a standard ISO 8601 format.     |
| UUID        | A UUID.                                      |

### Nested xemes

A xeme represents the results of a single process. However, a xeme can also
contain nested xemes which provide information about sub-processes. In this
sense, a xeme can be considered as the final results of the xemes nested within
it.

Child xemes are contained in the `nested` array.

```json
{
  "success":true,
  "meta": {"id":"directory"},
  "nested":[
    {"success":true, "meta": {"id":"database-connection"}},
    {"success":true, "meta": {"id":"update"}}
  ]
}
```

Nested xemes can themselves have nested xemes, forming a tree of process
results.

```json
{
  "success":true,
  "meta": {"id":"database"},
  "nested": [
    {
      "success":true,
      "meta": {"id":"database-connection"},
      "nested": [
        {"success":true, "meta":{"id":"initialization"}},
        {"success":true, "meta":{"id":"disconnection"}}
      ]
    }
  ]
}
```

### Resolution

Xeme operates on the concept of "least successful outcome". A xeme cannot
represent more success than its descendent xemes. So, for example, the following
structure contains conflicts:

```json
{
  "success":true,
  "nested":[
    {"success":false}
  ]
}
```

It is necessary to resolve these conflicts before the xeme can be considered
valid. A conforming processor should implement the following rules:

* If a xeme is marked as failure, all of its ancestor xemes should be marked
as failed. So the example above would be resolved as follows:

```json
{
  "success":false,
  "nested":[
    {"success":false}
  ]
}
```

A process can be marked as failed regardless of its nested xemes. So there is no
conflict in the following structure.

```json
{
  "success":false,
  "nested":[
    {"success":true}
  ]
}
```

* If a xeme's `success` is null, then all its ancestors' `success` values must
be set to null if they are not already set to false. The following structure is
invalid.

```json
{
  "success":true,
  "nested":[
    {"success":null}
  ]
}
```

It should be resolved as follows:

```json
{
  "success":null,
  "nested":[
    {"success":null}
  ]
}
```

### Advisory and promise xemes

Three types of Xemes operate on a different ruleset than standard xemes. Those
types are warnings, notes, and promises. They are indicated by the `type`
property:

```json
{"type": "warning"}
```

#### Warnings and notes

Warnings and notes provide advisory information about a process. They have no
affect on the success/failure determination. Warnings provide information about
non-fatal problems in a prosess. Notes do not indicate problems of any kind and
simply provide whatever arbitrary information might be useful. Advisory xemes
should not have `success` properties. So, for example, the following structure
is valid, even though the nested advisory xemes do not have `success`
properties.

```json
{
  "success":true,
  "nested":[
    {"type":"warning", "id":"invalid-setting"},
    {"type":"note", "id":"database-connected"}
  ]
}
```

Advisory xemes can have nested xemes. However, all descendents of an advisory
xeme should themselves be advisory.

#### Promises

A promise xeme indicates that the success/failure of a process has yet to be
determined. A promise should have a `success` value of null, unless it has also
has a truthy value in `supplanted`. For example, the following xemes are valid:

```json
{ "type":"promise" }
```

```json
{ "type":"promise", "supplanted":true, "success": true }
```

```json
{ "type":"promise", "supplanted":"2023-06-22T06:28:43+0000", "success": true }
```

Typically, a promise should have an indication of how the promise can be
resolved. For example, the following xeme is a promise, with further information
to indicate a URI where the final result can be determined, and how soon to
query that URI.

```json
{
  "type":"promise",
  "uri": "https://example.com/20435t",
  "delay": 6000
}
```

No standards are defined on how promises should provide such information. A
substandard may be defined down the road.

Best practice is that when a promise xeme is supplanted, it should have a nested
xeme that provides the final success/failure of the process.

```json
{
  "success": true,
  "supplanted": true,
  "type":"promise",
  "uri": "https://example.com/20435t",
  "delay": 6000,
  
  "nested": [
    {"success":true}
  ]
}
```