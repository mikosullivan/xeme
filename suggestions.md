= Suggestions for improvement

== Symbols as hash keys

In Xeme, strings (instead of symbols) are used as hash keys. The justification
for this choice is that sometimes hash keys are values when a method checks the
value of a hash key in Xeme#[]=.

One issue is in checking if the given key is acceptable, whether it is a string
or a symbol. It's necessary that both cases are checked.

However, that may be the wrong choice. Symbols are much more common as hash
keys. Advice and merge requests are welcome.

== Tests for UUIDs

The tests for Xeme#init_uuid and Xeme#uuid only check for the existence of the
UUID. They don't check if the value is a valid UUID. I'd like to more explicitly
test to make sure that valid UUIDs are used. However, I'm only familiar with the
string representation of a UUID, as opposed to its representations in
hexadecimal or otherwise, so I didn't go down the path of validating UUIDs.
Suggestions welcome.