#
# searcher.rb
#
# Copyright (c) 2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

require 'nkf'


module ReFe

  module Encoding

    def adjust_encoding( str )
      if shift_jis_platform?
        NKF.nkf('-Es', str)
      else
        str
      end
    end

    def shift_jis_platform?
      /mswin|mingw|cygwin|djgpp|vms/ === RUBY_PLATFORM
    end
  
  end


  class MethodSearcher

    include Encoding
    include TraceUtils

    def initialize( ctable, mtable, igraph, policy )
      @class_table = ctable
      @method_table = mtable
      @inheritance_graph = igraph
      @policy = policy
    end

    def search( keys )
      case keys.size
      when 0
        @policy.print_names @class_table.classes

      when 1
        key, = keys
        if /[\.\#\,]/ === key
          c, t, m = key.split(/([\.\#\,])/, 2)
          t = '#' if t == ','
          c = nil if c.empty?
          m = nil if m.empty?
          try c, t, m
        elsif /\A[A-Z]/ === key
          try key, nil, nil
        else
          begin
            try nil, nil, key
          rescue CompletionError
            try key, nil, nil
          end
        end

      when 2
        c, m = keys
        c, t, = c.split(/([\.\#\,])/, 2)
        t = '#' if t == ','
        try c, t, m
      
      when 3
        try(*keys)

      else
        raise '[ReFe BUG] argv > 3'
      end
    end

    private

    def try( c, t, m )
      if (c and m) or t
        trace 'search: type = Method'
        print_method @method_table.complete(c, t, m)
      elsif c
        trace 'search: type = Class'
        print_class @class_table.complete(c)
      else
        trace 'search: type = Method'
        print_method @method_table.complete(c, t, m)
      end
    end

    def print_class( results )
      unless @policy.should_print_content?(results)
        @policy.print_names results
        return
      end
      results.sort.each do |klass|
        s_top = @method_table.singleton_methods_of(klass, false)
        i_top = @method_table.instance_methods_of(klass, false)
        s_all = @method_table.singleton_methods_of(klass, true)
        i_all = @method_table.instance_methods_of(klass, true)
        print '==== ', klass, " ====\n"
        puts adjust_encoding(@class_table[klass])
        puts '---- Singleton methods ----'
        @policy.print_names(s_top)
        puts '---- Instance methods ----'
        @policy.print_names(i_top)
        puts '---- Singleton methods (inherited) ----'
        @policy.print_names(s_all - s_top)
        puts '---- Instance methods (inherited) ----'
        @policy.print_names(i_all - i_top)
      end
    end

    def print_method( results )
      unless @policy.should_print_content?(results)
        @policy.print_names results.map {|sp| sp.sub(/\A@/, '') }
        return
      end
      results.sort.each do |spec|
        if /\A@/ === spec
          orig = method_origin(spec.sub(/\A@/, ''))
          puts spec.sub(/\A@/, '').split(/[\.\#]/)[0] + ' < ' + orig
          puts adjust_encoding(@method_table[orig])
        else
          puts spec
          puts adjust_encoding(@method_table[spec])
        end
      end
    end

    def method_origin( spec )
      c, m = spec.split(/[\.\#]/)
      @inheritance_graph.ancestors_of(c).each do |klass|
        sp = "#{klass}\##{m}"
        return sp if @method_table.key?(sp)
      end
      raise DatabaseError, "ReFe database missmatch: cannot resolve symbol `#{spec}'"
    end

  end


  class FunctionSearcher

    include Encoding

    def initialize( table, policy )
      @table = table
      @policy = policy
    end

    def search( keys )
      results = @table.complete(keys)
      if @policy.should_print_content?(results)
        results.sort.each do |name|
          puts adjust_encoding(@table[name])
        end
      else
        @policy.print_names results
      end
    end

  end


  class OutputPolicy

    def OutputPolicy.new2( opts )
      new(opts['all'], opts['short'], opts['line'])
    end

    def initialize( all, short, line )
      @all = all
      @short = short
      @line = line
    end

    def should_print_content?( results )
      return false if @short
      return true if @all
      results.size == 1
    end

    def print_names( list )
      if @line
        list.sort.each do |i|
          puts i
        end
      else
        packed_print list
      end
    end

    LINE_MAX = 60

    def packed_print( list )
      return if list.empty?
      len = 0
      sep = ''
      list.sort.each do |word|
        if len != 0 and (len + sep.size + word.size > LINE_MAX)
          sep = "\n"; len = 0
        end
        print sep, word; len += sep.size + word.size
        sep = ' '
      end
      puts
    end

  end

end
