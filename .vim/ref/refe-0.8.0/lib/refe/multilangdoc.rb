#
# multilangdoc.rb
#
# Copyright (c) 2003 Minero Aoki
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU LGPL, Lesser General Public License version 2.
# For details of GNU LGPL, see the file "COPYING".
#
# $ docutils Id: multilangdoc.rb,v 1.4 2003/08/02 14:28:15 aamine Exp $
#

class MultilangDocument

  def MultilangDocument.extract( f, lang )
    buf = ''
    new(f,lang).each do |line|
      buf << line
    end
    buf
  end

  def initialize( f, lang )
    @src = f
    @lang = lang
    @eof = false
    @on = true
  end

  def gets
    while line = @src.gets
      case line
      when /\A([a-z])\s*\z/
        @on = ($1 == @lang[0,1])
      when /\A\.\s*\z/
        @on = true
      else
        return line if @on
      end
    end
    @eof = true
    nil
  end

  def eof?
    @eof
  end

  def each
    @src.each do |line|
      case line
      when /\A([a-z])\s*\z/
        @on = ($1 == @lang[0,1])
      when /\A\.\s*\z/
        @on = true
      else
        yield line if @on
      end
    end
    @eof = true
  end
  
end
