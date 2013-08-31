#
# rdutils.rb
#
# Copyright (c) 2001-2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# you can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

module ReFe

  module RDUtils

    def untag( str )
      return nil unless str
      str.gsub(/\(\([{|']|[}|']\)\)/, '')           \
         .gsub(/^\s*\(\(-.*?-\)\)\s*\n/s, '')       \
         .gsub(/\(\(-.*?-\)\)/m, '')                \
         .gsub(/\(\(<(.*?)\|(.*?)>\)\)/, '\1 [\2]') \
         .gsub(/\(\(<(.*?)\/"?(.*?)"?>\)\)/, '\2')  \
         .gsub(/\(\(<|>\)\)/, '')
    end
    module_function :untag

  end

end
