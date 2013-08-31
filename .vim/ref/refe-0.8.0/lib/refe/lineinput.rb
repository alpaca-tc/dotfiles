#
# lineinput.rb
#
# Copyright (c) 2002-2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#
# $ docutils Id: lineinput.rb,v 1.1 2003/08/02 14:48:40 aamine Exp $
#

class LineInput

  def initialize( f )
    @input = f
    @buf = []
    @lineno = 0
    @eof_p = false
  end

  def eof?
    @buf.empty? and @input.eof?
  end

  def lineno
    @lineno
  end

  def gets
    @lineno += 1
    if @buf.empty?
      if @eof_p     # to avoid ARGF blocking.
        nil
      else
        line = @input.gets
        @eof_p = true unless line
        line
      end
    else
      @buf.pop
    end
  end

  def ungets( line )
    return unless line
    @buf.push line
    line
  end

  #def save_index
  #  begin
  #    save = @i
  #    yield
  #  ensure
  #    @i = save
  #  end
  #end

  def gets_if( re )
    line = gets()
    if not line or not (re === line)
      ungets line
      return nil
    end
    line
  end

  def gets_unless( re )
    line = gets()
    if not line or re === line
      ungets line
      return nil
    end
    line
  end

  def while_match( re )
    while line = gets()
      unless re === line
        ungets line
        return
      end
      yield line
    end
    nil
  end

  def until_match( re )
    while line = gets()
      if re === line
        ungets line
        return
      end
      yield line
    end
    nil
  end

  def until_terminator( re )
    while line = gets()
      return if re === line   # discard terminal line
      yield line
    end
    nil
  end

end
