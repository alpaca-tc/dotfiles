#
# mfrelationparser.rb
#
# Copyright (c) 2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

module ReFe

  class MFRelationParser

    def parse( f )
      relations = {}
      while line = f.gets
        if /\AInit_/ === line
          add_relations relations, f
        end
      end
      relations
    end

    private

    DEFFUNC_TABLE = {
      'rb_define_method'           => false,
      'rb_define_singleton_method' => false,
      'rb_define_module_function'  => false,
      'rb_define_global_function'  => ['Kernel.'],
      'define_filetest_function'   => ['File.', 'FileTest.']
    }

    DEFFUNC_RE = Regexp.new('\A\s+(' + DEFFUNC_TABLE.keys.join('|') + ')\(')

    def add_relations( relations, f )
      while line = f.gets
        return if /\A\}/ === line
        next unless DEFFUNC_RE === line

        until balanced?(line)
          line << f.gets.strip
        end
        deffunc = DEFFUNC_RE.match(line)[1]
        if types = DEFFUNC_TABLE[deffunc]
          types.each do |t|
            relations[t + getmethod(line)] = get_function_name(line)
          end
        else
          relations[get_method_name(line)] = get_function_name(line)
        end
      end
    end

    def balanced?( line )
      line.count('(') == line.count(')')
    end

    def get_method_name( line )
      getclass(line) + getmethod(line)
    end

    def getclass( line )
      var2class(getcvar(line) + deftype(line))
    end

    def getcvar( line )
      # the first argument
      m = /\((\w+)/.match(line) or
              raise ArgumentError, "cannot find class name: #{line}"
      m[1]
    end

    def deftype( line )
      /define_singleton|module_function/ === line ? '.' : '#'
    end

    VAR_TO_CLASS = {
      'rb_mKernel#'      => 'Object#',
      'rb_cStat.'        => 'File::Stat.',
      'rb_cStat#'        => 'File::Stat#',
      'rb_cProcStatus.'  => 'Process::Status.',
      'rb_cProcStatus#'  => 'Process::Status#',
      'argf.'            => 'ARGF#',
      'envtbl.'          => 'ENV#',
      'ruby_top_self.'   => 'main#',
      'mSignal.'         => 'Signal.',
      'cThGroup.'        => 'ThreadGroup.',
      'cThGroup#'        => 'ThreadGroup#'
    }

    def var2class( var )
      c = VAR_TO_CLASS[var] and return c
      /\Arb_[cme][A-Z]/ === var or
              raise ArgumentError, "cannot find class name: #{var}"
      var.sub(/\Arb_[cme]/, '')
    end

    def getmethod( line )
      # the first quoted word
      m = /"([^"\\]+|\\.)*"/.match(line) or
              raise ArgumentError, "cannot find method name: #{line}"
      m[0][1..-2]
    end

    def get_function_name( line )
      # the word after first quoted word (2nd/3rd argument)
      m = /\((?:\w+,\s*)?"[^"\\]+",\s*(\w+),/.match(line) or
              raise ArgumentError, "cannot find function name: #{line}"
      m[1]
    end
  
  end

end
