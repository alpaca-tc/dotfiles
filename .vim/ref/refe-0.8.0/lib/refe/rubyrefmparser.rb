#
# rubyrefmparser.rb
#
# Copyright (c) 2002,2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

require 'refe/lineinput'
require 'refe/rdutils'


module ReFe

  class RubyReferenceManualParser

    const = '[A-Z]\w+'
    constpath = '[A-Z]\w+(?:\::[A-Z]\w+)*'
    CLASS_BEGIN = [
      [/\A= (#{constpath})\s*$/n,                               nil],
      [/\A={2,3} (#{const}(?:\::#{const})+)\s/n,                nil],
      [/\A={1,3} (?:[Cc]lass|[Mm]odule)\s+(#{constpath})/n,     nil],
      [/\A={1,3} (#{constpath})\s+(?:[Cc]lass|[Mm]odule)/n,     nil],
      [/\A={1,3} \(\(:(#{constpath}):\)\)/n,                    nil],
      [/\A= fatal/n,                                           'fatal'],
      [/\A=== 構造体クラスのクラスメソッド/e,                  'Struct::XXX'],
      [/\A= 組み?込み関数/e,                                   'Kernel'],
      [/\A= 組み?込み定数/e,                                   'Kernel']
    ]

    reject_titles = %w(
      BeOS Cygwin DJGPP Example GNU Mac MinGW
      Miscellaneous OS2 Unix VMS Win32 WindowsCE
      Summary
    )
    CLASS_REJECT = /\A(?:#{ reject_titles.join('|') })\z/

    SINGLETON_METHODS_BEGIN = [
      /\A={2,3} クラスメソッド/e,
      /\A={2,3} モジュール関数/e,
      /\A={2,3} モジュール属性/e,
      /\A={2,3} モジュールメソッド/e,
      /\A={2,4} Module Functions?/i,
      /\A={2,4} Class Methods?/i,
      /\A={2,4} Singleton Methods?/i
    ]

    INSTANCE_METHODS_BEGIN = [
      /\A={2,3} メソッド/e,
      /\A={2,3} プライベートメソッド/e,
      /\A={2,4} Instance Methods?/i,
      /\A={2,4} Methods?/i
    ]

    def parse( input )
      @current_input = input
      classes = {}   # {class => description}
      methods = {}   # {class[#.] => {method => description}}
      current_class = nil
      s_table = nil
      m_table = nil
      tbl = nil
      off = false

      f = LineInput.new(input)
      while line = f.gets
        case line
        when /\A\#\#\#/
          return classes, methods if /\bnonref\b/ === line
        when /\A=+\s/
          case line
          when *SINGLETON_METHODS_BEGIN
            tbl = s_table
            off = false
          when *INSTANCE_METHODS_BEGIN
            tbl = m_table
            off = false
          when /\A= sprintfフォーマット/
            (methods['man.'] ||= {})['sprintf'] = read_page(f, line)
            classes['man'] = ''
          when /\A= packテンプレート文字列/
            (methods['man.'] ||= {})['pack'] = read_page(f, line)
            classes['man'] = ''
          else
            off = true
            if /\A= / === line
              current_class = nil
              s_table = m_table = tbl = nil
            end
            CLASS_BEGIN.each do |re, static_mname|
              m = re.match(line) or next
              c = (static_mname || m[1])
              next if CLASS_REJECT === c

              current_class = c
              buf = ''
              f.until_match(/\A[\=\-]/) do |line|
                buf << line
              end
              classes[current_class] ||= RDUtils.untag(buf.strip)
              s_table = (methods[current_class + '.'] ||= {})
              m_table = (methods[current_class + '#'] ||= {})
              tbl = m_table
              off = false
              break
            end
          end

        when /\A(?:---|:) (?>[A-Z\d_:]+)\s/   # constants
          next unless s_table
          register_entry_to s_table, line, f

        when /\A(?:---|:)\s/   # method
          if /\A--- ([\w:]+[\.\#])/ === line   # context independent entry
            spec = $1
            tmp = (methods[spec] ||= {})
            register_entry_to tmp, line, f
          else
            next unless tbl
            next if off
            register_entry_to tbl, line, f
          end
        end
      end

      return classes, methods
    end

    def read_page( f, first_line )
      buf = ''
      buf << first_line
      f.until_match(/\A= /) do |line|
        buf << line unless /\A\#\#\# / === line
      end
      RDUtils.untag(buf.strip)
    end

    def register_entry_to( table, first_line, f )
      mnames, ent = read_entry(first_line, f)
      if desc = find_same_method(table, mnames)
        desc << ent
      else
        desc = ent
      end
      mnames.each do |name|
        table[name] = desc
      end
    end

    def read_entry( first_line, f )
      buf = ''
      buf << first_line
      mnames = [get_method_name(first_line, f)]

      # check method aliases
      f.while_match(/\A(?:---|:)/) do |line|
        buf << line
        mnames.push get_method_name(line, f)
      end

      # read description
      f.until_match(/\A(?:---|:|=)/) do |line|
        buf << line
      end

      return mnames, RDUtils.untag(buf).strip + "\n\n"
    end

    def find_same_method( table, mnames )
      a = mnames.map {|n| table[n] }.compact.uniq
      raise 'fatal: inconsistent document; cannot parse' if a.length > 1
      a[0]
    end

    def get_method_name( line, f )
      _get_method_name(line) or
          raise "\n#{File.basename(curfile().path)}:#{curfile().lineno}: " +
                "cannot get method name\n#{line.inspect}\n"
    end

    def curfile
      if @current_input.respond_to?(:file)   # ARGF?
        @current_input.file
      else
        @current_input
      end
    end

    def _get_method_name( line )
      case line
      when /\A(?:---|:)\s*([\w:\.\#]+[?!]?)\s*(?:[\(\{]|--|->|\z)/
           # name(arg), name{}, name,
           # name() -- obsolete
           # name() -> return value type
        remove_class_spec($1)
      when /\A---\s*[\w:]+[\.\#]([+\-<>=~*^&|%\/]+)/         # Complex#+
        $1
      when /\A(?:---|:)\s*self\s*(==|===|=~)\s*\w+/          # self == other
        $1
      when /\A(?:---|:)\s*([\w:\.\#]+)\s*\=(?:\(|\s*\w+)?/   # name=
        remove_class_spec($1) + '='
      when /\A(?:---|:)\s*\w+\[.*\]=/                        # self[key]=
        '[]='
      when /\A(?:---|:)\s*[\w\:]+\[.*\]/                     # self[key]
        '[]'
      when /\A(?:---|:)\s*self\s*([+\-<>=~*^&|%\/]+)\s*\w/   # self + other
        $1
      when /\A(?:---|:)\s*([+\-~`])\s*\w+/                   # ~ self
        case op = $1
        when '+', '-' then op + '@'
        else               op
        end
      when /\A(?:---|:)\s*(?:[\w:]+[\.\#])?(\[\]=?)/         # Matrix.[](i)
        $1
      when /\A(?:---|:)\s*([+\-<>=~*^&|%]+)/                 # +(m)
        $1
      when /\A(?:---|:)\s*([A-Z]\w+\*)/                      # HKEY_*
        $1
      else
        nil
      end
    end

    def remove_class_spec( str )
      str.sub(/\A[A-Z]\w*(?:::[A-Z]\w*)*[\.\#]/, '')
    end
  
  end

end

# memo: '組込みクラス／モジュール／例外クラス'
# memo: '添付ライブラリ'
