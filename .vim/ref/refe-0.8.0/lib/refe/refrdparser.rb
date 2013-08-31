#
# refrdparser.rb
#
# Copyright (c) 2002,2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

require 'refe/lineinput'


module ReFe

  class ReferenceRDParser

    def parse( f )
      classes = {}   # {class => description}
      methods = {}   # {class[#.] => {method => description}}
      current_class = nil
      s_table = nil
      m_table = nil
      tbl = nil

      f = LineInput.new(f)
      while line = f.gets
        case line
        when /\A=+\s/
          case line
          when /\A==? (?:class|module) ([A-Z][\w:]+)/
            current_class = $1
            raise "class duplicated: #{current_class}" if classes.key?(current_class)
            classes[current_class] = read_class_document(f)
            s_table = (methods[current_class + '.'] ||= {})
            m_table = (methods[current_class + '#'] ||= {})
            tbl = nil
          when /\A===? (?:Class Methods|Module Functions)/
            tbl = s_table
          when /\A===? Instance Methods/
            tbl = m_table
          when /\A= /
            current_class = nil
            s_table = m_table = tbl = nil
          end

        when /\A: /
          next unless tbl
          mnames, ent = read_entry(f, line)
          if desc = find_same_method(tbl, mnames)
            desc << ent
          else
            desc = ent
          end
          mnames.each do |name|
            tbl[name] = desc
          end
        end
      end

      return classes, methods
    end

    def read_class_document( f )
      buf = ''
      f.until_match(/\A[\=\-]/) do |line|
        buf << line
      end
      buf.strip
    end

    def read_entry( f, first_line )
      buf = ''
      buf << first_line
      mnames = [get_method_name(first_line, f)]

      # check method aliases
      f.while_match(/\A: /) do |line|
        buf << line
        mnames.push get_method_name(line, f)
      end

      # read description
      f.until_match(/\A(?:=+ |: )/) do |line|
        buf << line
      end

      return mnames, buf.strip + "\n\n"
    end

    def find_same_method( table, mnames )
      a = mnames.map {|n| table[n] }.compact.uniq
      raise 'fatal: inconsistent document; cannot parse' if a.length > 1
      a[0]
    end

    def get_method_name( line, f )
      n = _get_method_name(line)
      unless n
        p f.lineno
        p line
        raise 'cannot get method name'
      end
      n
    end

    def _get_method_name( line )
      line.slice(/\A: (\w+[?!=]?|==|\[\]|\[\]=|\+|\-|<=>|=~|~)/, 1)
    end
  
  end

end
