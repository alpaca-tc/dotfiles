#
# rubysrcparser.rb
#
# Copyright (c) 2002,2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

module ReFe

  class RubySourceCodeParser

    def parse( f )
      table = {}
      header = nil

      while line = f.gets
        case line
        when /\Atypedef/
          ;
        when /\A\w/
          unless header
            header = ''
            lineno_save = f.lineno
          end
          header << line
        when /\A\s*\z/
          header = nil
        when /\A\{/
          if header
            table[get_function_name(header)] =
                    [ header, read_body(f, line), lineno_save ]
          end
          header = nil
        else
          header << line if header
        end
      end

      table
    end

    private

    def get_function_name( header )
      header.split(/\n/).reverse_each do |line|
        /\A\w/ === line and
            not /NORETURN/ === line and
            m = /(\w+)(?:\s*|\s+_)\(/.match(line) and
            return m[1]
      end
      raise ArgumentError, "cannot get function name: #{header}"
    end

    def read_body( f, first_line )
      body = first_line.dup
      while line = f.gets
        body << line
        return body if /\A\};?\s*\z/ === line
      end
      raise ArgumentError, "unexpected EOF"
    end
  
  end

end
