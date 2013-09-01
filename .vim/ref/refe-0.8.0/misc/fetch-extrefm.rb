#!/usr/bin/env ruby

HOST = 'www.rubyist.net'
PATH = '/~rubikitch/RDP.cgi'
INDEX = '%B3%C8%C4%A5%A5%E9%A5%A4%A5%D6%A5%E9%A5%EA%A5%EA%A5%D5%A5%A1%A5%EC%A5%F3%A5%B9%A5%DE%A5%CB%A5%E5%A5%A2%A5%EB'

require 'net/http'
Net::HTTP.version_1_2

def exist_pages( h )
  h.get("#{PATH}?cmd=view&name=#{INDEX}").body\
          .scan(/cmd=view;name=(\w+\.[chy])/).map {|n,| n }.uniq.sort
end

Net::HTTP.start(HOST) {|h|
    exist_pages(h).each do |name|
      h.get("#{PATH}?cmd=src&name=#{name}") do |s|
        print s
      end
    end
}
