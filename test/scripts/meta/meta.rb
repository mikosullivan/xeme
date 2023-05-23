#!/usr/bin/ruby -w
require_relative './dir.rb'

# Tests xeme.meta

# init
xeme = Xeme.new

# add meta information
xeme.meta

# test meta elements
Bryton::Lite::Tests.assert xeme.meta.is_a?(Hash)

# test uuid
Bryton::Lite::Tests.assert xeme.meta['uuid'].match(/\A[a-z0-9]{8}(\-[a-z0-9]{4}){3}\-[a-z0-9]{11}/mu)
Bryton::Lite::Tests.assert xeme.uuid.match(/\A[a-z0-9]{8}(\-[a-z0-9]{4}){3}\-[a-z0-9]{11}/mu)

# timestamp should be valid time
Bryton::Lite::Tests.assert xeme['meta']['timestamp'].is_a?(Time)
Bryton::Lite::Tests.assert xeme.timestamp.is_a?(Time)

# id should be nil
Bryton::Lite::Tests.assert xeme['meta']['id'].nil?
Bryton::Lite::Tests.assert xeme.id.nil?

# set id
xeme.id = 'my-id'
Bryton::Lite::Tests.assert_equal 'my-id', xeme['meta']['id']
Bryton::Lite::Tests.assert_equal 'my-id', xeme.id

# done
Bryton::Lite::Tests.done