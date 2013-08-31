#!/usr/bin/env ruby
require 'net/http'
Net::HTTP.get_print 'www.ruby-lang.org', '/ja/man/man-rd-ja.tar.gz'
