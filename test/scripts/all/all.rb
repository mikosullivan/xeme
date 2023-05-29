#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.all.

# init
xeme = nester()

# all should return a frozen array
Bryton::Lite::Tests.assert xeme.all.frozen?

# should have three xemes
Bryton::Lite::Tests.assert_equal nester_max(), xeme.all.length

# done
Bryton::Lite::Tests.done