#
# database.rb
#
# Copyright (c) 2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

require 'refe/fsdbm'
require 'refe/completiontable'
require 'refe/inheritancegraph'
require 'refe/fileutils'
require 'refe/traceutils'
begin
  require 'refe/config'
rescue LoadError
end


module ReFe

  class Error < StandardError; end
  class FatalError < StandardError; end
  class CompletionError < Error; end
  class DatabaseError < Error; end
  class LookupError < FatalError; end


  class Database

    include ReFe::FileUtils

    def initialize( rootdir = nil, init = false )
      @init = init
      if rootdir
        @rootdir = rootdir
      elsif ENV['REFE_DATA_DIR']
        @rootdir = ENV['REFE_DATA_DIR']
      elsif defined?(REFE_DATA_DIR)
        @rootdir = REFE_DATA_DIR
      else
        raise ArgumentError, 'ReFe database directory not given'
      end
      isdbdir @rootdir

      @class_document_dbm          = nil
      @class_document_comptable    = nil
      @method_document_dbm         = nil
      @method_document_comptable   = nil
      @mf_relation_dbm             = nil
      @mf_relation_comptable       = nil
      @function_document_dbm       = nil
      @function_document_comptable = nil
      @function_source_dbm         = nil
      @function_source_comptable   = nil
    end

    #
    # facades
    #

    def class_document
      ClassTable.new(class_document_dbm(),
                     class_document_comptable())
    end

    def method_document
      MethodTable.new(method_document_dbm(),
                      method_document_comptable())
    end

    def mf_relation
      MFRelationTable.new(method_document(),
                          mf_relation_dbm(),
                          mf_relation_comptable(),
                          function_source())
    end

    def function_document
      FunctionTable.new(function_document_dbm(),
                        function_document_comptable())
    end

    def function_source
      FunctionTable.new(function_source_dbm(),
                        function_source_comptable())
    end

    def inheritance_graph
      InheritanceGraph.parse(isdbfile(@rootdir + '/inheritance_graph'))
    end

    #
    # low level database
    #

    private

    def class_document_dbm
      @class_document_dbm ||= FSDBM.new(isdbdir(@rootdir + '/class_document'))
    end

    def class_document_comptable
      @class_document_comptable ||=
        CompletionTable.new(isdbfile(@rootdir + '/class_document_comp'), @init)
    end

    def method_document_dbm
      @method_document_dbm ||= FSDBM.new(isdbdir(@rootdir + '/method_document'))
    end

    def method_document_comptable
      @method_document_comptable ||=
        CompletionTable.new(method_comp_file(), @init)
    end

    def method_comp_file
      isdbfile(@rootdir + '/method_document_comp')
    end
    public :method_comp_file   # for inheritance graph extention

    def mf_relation_dbm
      @mf_relation_dbm ||= FSDBM.new(isdbdir(@rootdir + '/mf_relation'))
    end

    def mf_relation_comptable
      @mf_relation_comptable ||=
        CompletionTable.new(isdbfile(@rootdir + '/mf_relation_comp'), @init)
    end

    def function_document_dbm
      @function_document_dbm ||=
        FSDBM.new(isdbdir(@rootdir + '/function_document'))
    end

    def function_document_comptable
      @function_document_comptable ||=
        CompletionTable.new(isdbfile(@rootdir+'/function_document_comp'), @init)
    end

    def function_source_dbm
      @function_source_dbm ||=
        FSDBM.new(isdbdir(@rootdir + '/function_source'))
    end

    def function_source_comptable
      @function_source_comptable ||=
        CompletionTable.new(isdbfile(@rootdir + '/function_source_comp'), @init)
    end

    private

    def isdbdir( dir )
      unless File.directory?(dir)
        raise ArgumentError, "database not initialized: #{dir}" unless @init
        mkdir_p dir
      end
      dir
    end

    def isdbfile( file )
      unless File.file?(file)
        raise ArgumentError, "database not initialized: #{file}" unless @init
      end
      file
    end
  
  end


  class ClassTable

    include TraceUtils

    def initialize( dbm, comp )
      @dbm = dbm
      @comp = comp
    end

    def flush
      @comp.flush
    end

    def classes
      @comp.list
    end

    def []( name )
      @dbm[name] or raise LookupError, "class not found: #{name}"
    end

    def []=( name, content )
      @comp.add name
      @dbm[name] = content
    end

    def complete( pattern )
      list = @comp.expand(compile_pattern(pattern))
      raise CompletionError, "not match: #{pattern}" if list.empty?
      trace "class comp/1: list.size = #{list.size}"
      return list if list.size == 1

      list.each do |n|
        if n == pattern
          trace "class comp/2: exact match"
          return [n]
        end
      end

      trace "class comp: completion failed"
      list
    end

    private

    def compile_pattern( pattern )
      flags = (/[A-Z]/ === pattern ? 'n' : 'ni')
      pat = pattern.gsub(/\\.|\[\]|\*|\?/) {|s|
        case s
        when /\A\\/
          s
        when '[]'
          '\\[\\]'
        when '*'
          '.*'
        when '?'
          '.'
        end
      }
      Regexp.compile("\\A#{pat}", flags)
    end

  end


  module MethodCompletion

    include TraceUtils

    private

    def complete0( table, comptable, c, t, m )
      extended_completion = (c && m)
      items = comptable.expand(build_regexp(c, t, m, extended_completion))
      raise CompletionError, "not match: #{c}#{t || ' '}#{m}" if items.empty?
      catch_specified {
        try items, table, c, t, m
        try reject_inherited(items), table, c, t, m if extended_completion
      } || items
    end

    def reject_inherited( specs )
      specs.reject {|s| /\A@/ === s }
    end

    def catch_specified
      catch(:specified) {
        yield
        trace "method comp: reduction failed"
        nil
      }
    end

    def return_if_specified( mid, *args )
      items = __send__(mid, *args)
      trace "method comp (#{mid}): size = #{items.size}"
      if items.size == 1
        trace "method comp: specified: #{items[0]}"
        throw :specified, items
      end
    end

    def try( items, table, c, t, m )
      # weak -> strong
      return_if_specified :noop,                         items
      return_if_specified :method_exact_match,           items, m     if m
      return_if_specified :class_exact_match,            items, c     if c
      return_if_specified :class_and_method_exact_match, items, c, m  if c and m
      return_if_specified :unify_if_differ_only_suffix,  items
      return_if_specified :unify_if_contents_are_same,   items, table if belongs_to_one_class?(items)
    end

    def noop( items )
      items
    end

    def method_exact_match( items, mtarget )
      items.select {|spec|
        c, t, m = spec.sub(/\A@/, '').split(/([\.\#])/, 2)
        m.downcase == mtarget.downcase
      }
    end

    def class_exact_match( items, ctarget )
      items.select {|spec|
        c, t, m = spec.sub(/\A@/, '').split(/([\.\#])/, 2)
        c.downcase == ctarget.downcase
      }
    end

    def class_and_method_exact_match( items, ctarget, mtarget )
      items.select {|spec|
        c, t, m = spec.sub(/\A@/, '').split(/([\.\#])/, 2)
        c.downcase == ctarget.downcase and m.downcase == mtarget.downcase
      }
    end

    def unify_if_differ_only_suffix( items )
      items.map {|spec| spec.sub(/\A@/, '').sub(/[!?]\z/, '') }.uniq
    end

    def belongs_to_one_class?( items )
      items.map {|spec| spec.slice(/\A[\w:]+[\.\#]/) }.uniq.size == 1
    end

    def unify_if_contents_are_same( items, db )
      h = {}
      items.each do |spec|
        next if /\A@/ === spec
        (h[db[spec]] ||= []).push spec
      end
      h.values.map {|specs| specs[0] }
    end

    def build_regexp( c, t, m, extended )
      /#{class_re(c, extended)}#{type_re(t)}#{method_re(m)}/
    end

    def class_re( c, extended_completion )
      if extended_completion
        if c
        then '\\A@?' + compile_class(c) + '.*'
        else ''
        end
      else
        if c
        then '\\A' + compile_class(c) + '.*'
        else '\\A[^@].*'
        end
      end
    end

    def compile_class( c )
      ignore_case_p = !c.index(/[A-Z]/)
      c.gsub(/\\.|\[.*?\]|[a-z\*\?]/) {|s|
        case s
        when /\A\\/  then s
        when '*'     then '.*'
        when '?'     then '.'
        when /\A\[/  then s
        when /[a-z]/ then ignore_case_p ? "[#{s}#{s.upcase}]" : s
        else
          raise 'must not happen'
        end
      }
    end

    def method_re( m )
      return '' unless m
      ignore_case_p = !m.index(/[A-Z]/)
      m.gsub(/\\.|\[\]|\[.*?\]|[a-z]|([!?]\z)|[*?]/) {|s|
        on_tail = $1
        case s
        when /\A\\/  then s
        when '[]'    then '\\[\\]'
        when '*'     then '.*'
        when '?'     then on_tail ? '.*\\?\\z' : '.'
        when '!'     then '.*!\\z'
        when /\A\[/  then s
        when /[a-z]/ then ignore_case_p ? "[#{s}#{s.upcase}]" : s
        else
          raise 'must not happen'
        end
      }
    end

    def type_re( t )
      return '[\\.\\#]' unless t
      case t
      when '.' then '\\.'
      when '#' then '#'
      else
        raise ArgumentError, "invalid type specifier: #{t.inspect}"
      end
    end
  
  end


  class MethodTable

    include MethodCompletion

    def initialize( dbm, comp )
      @dbm = dbm
      @comp = comp
    end

    def flush
      @comp.flush
    end

    def singleton_methods_of( c, include_super )
      if include_super
        @comp.expand(/\A@#{c}\./).map {|n| n.sub(/\A@[\w:]+\./, '') }
      else
        @comp.expand(/\A#{c}\./).map {|n| n.sub(/\A[\w:]+\./, '') }
      end
    end

    def instance_methods_of( c, include_super )
      if include_super
        @comp.expand(/\A@#{c}#/).map {|n| n.sub(/\A@[\w:]+#/, '') }
      else
        @comp.expand(/\A#{c}#/).map {|n| n.sub(/\A[\w:]+#/, '') }
      end
    end

    def []( name )
      c, t, m = name.split(/([\.\#])/, 2)
      @dbm[c + t, m] or
          raise LookupError, "method not found: #{name}"
    end

    def []=( spec, content )
      c, t, m = spec.split(/([\.\#])/, 2)
      raise "missing class: #{spec.inspect}" unless c
      raise "missing type: #{spec.inspect}" unless t
      raise "missing method: #{spec.inspect}" unless m
      @dbm[c + t, m] = content
      @comp.add spec
      content
    end

    def key?( name )
      c, t, m = name.split(/([\.\#])/, 2)
      @dbm[c + t, m] ? true : false
    end

    def complete( c, t, m )
      complete0(self, @comp, c, t, m)
    end

  end


  class MFRelationTable

    include MethodCompletion

    def initialize( mdoc, mtof_dbm, mtof_comp, fsrc )
      @mdoc = mdoc
      @mtof_dbm = mtof_dbm
      @mtof_comp = mtof_comp
      @fsrc = fsrc
    end

    def flush
      @mtof_comp.flush
    end

    def []( method )
      c, t, m = method.split(/([\.\#])/, 2)
      f = @mtof_dbm[c + t, m] or
              raise LookupError, "cannot convert method to function: #{method}"
      @fsrc[f]
    end

    def []=( method, function )
      c, t, m = method.split(/([\.\#])/, 2)
      @mtof_dbm[c + t, m] = function
      @mtof_comp.add method
      function
    end

    def complete( c, t, m )
      complete0(self, @mtof_comp, c, t, m)
    end

  end


  class FunctionTable
  
    include TraceUtils

    def initialize( dbm, comp )
      @dbm = dbm
      @comp = comp
    end

    def flush
      @comp.flush
    end

    def []( name )
      @dbm[*name.split(/_/)] or
          raise LookupError, "function not found: #{name}"
    end

    def []=( name, content )
      @comp.add name
      @dbm[*name.split(/_/)] = content
    end

    def complete( words )
      pattern = normalize(words)

      items = @comp.expand(compile_pattern(pattern))
      trace "function: comp/1: items.size = #{items.size}"
      raise CompletionError, "not match: #{words.join(' ')}" if items.empty?
      return items if items.size == 1

      words = pattern.split(/_/)
      alt1 = items.select {|func|
        tmp = func.split(/_/)
        (tmp.size == words.size) and (tmp[-1] == words[-1])
      }
      trace "function: comp/2: alt1.size = #{alt1.size}"
      return alt1 if alt1.size == 1

      items
    end

    private

    def normalize( words )
      words.join('_').tr('-', '_').squeeze('_').sub(/\A_/, 'rb_')
    end

    def compile_pattern( pattern )
      Regexp.compile('\\A' + pattern.split(/_/).join('[^_]*_'),
                     (pattern.index(/[A-Z]/) ? 'n' : 'in'))
    end

  end

end
