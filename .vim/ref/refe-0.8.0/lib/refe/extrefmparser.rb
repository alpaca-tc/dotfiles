#
# extrefmparser.rb
#
# Copyright (c) 2002,2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# you can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

require 'refe/lineinput'
require 'refe/rdutils'

class String
  def first_line
    slice(/\A.*/)
  end
end

module ReFe

  class ExtentionAPIReferenceManualParser

    def parse( f )
      table = {}   # {function_name => description}

      f = LineInput.new(f)
      while line = f.gets
        case line
        when /\A[=\w]/
          ;
        when /\A: /
          buf = ''
          buf << line
          f.until_match(/\A\S/) do |line|
            buf << line
          end
          table[function_name(buf)] = RDUtils.untag(buf).strip + "\n\n"
        end
      end

      table
    end

    def function_name( str )
      case str.first_line
      when /(\w+)\(/n, /(\w+)/n
        return $1
      else
        raise "parse failed: #{str.inspect}"
      end
    end
  
  end

end
