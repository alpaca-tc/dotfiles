#
# inheritancegraph.rb
#
# Copyright (c) 2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

module ReFe

  class InvalidGraph < StandardError; end

  class InheritanceGraph

    def InheritanceGraph.parse( path )
      graph = new()
      File.foreach(path) do |line|
        next if line.sub(/\A\#.*/, '').strip.empty?
        dest, op, src = line.split
        case op
        when '<-'   # include
          graph.add_include_edge dest, src
        when '<'   # inheritance
          graph.add_class_node dest, src
        end
      end
      graph
    end

    def initialize
      @nodes = {}
      @nodes['Object'] = ClassNode.new('Object', nil)
    end

    def ancestors_of( name )
      if @nodes[name]
        @nodes[name].ancestors.map {|node| node.name }
      else
        [name]
      end
    end

    def add_include_edge( dest, incl )
      raise InvalidGraph, "include given before definition: #{dest}"\
          unless @nodes[dest]
      @nodes[dest].include module_node(incl)
    end

    def add_class_node( name, super_class )
      raise InvalidGraph, "same class given twice: #{name}" if @nodes[name]
      @nodes[name] = ClassNode.new(name, class_node(super_class))
    end

    private

    def module_node( name )
      @nodes[name] ||= ModuleNode.new(name)
    end

    def class_node( name )
      @nodes[name] or
          raise ArgumentError, "class not registered: #{name}"
    end
  
  end


  class ModuleNode

    def initialize( name )
      @name = name
      @included = []
    end

    attr_reader :name

    def inspect
      "\#<#{self.class} #{@name}>"
    end

    def include( mod )
      @included.unshift mod
    end

    def ancestors
      result = [self]
      @included.each do |mod|
        result.concat mod.ancestors
      end
      result.uniq   # uniq is ReFe specific
    end

  end


  class ClassNode < ModuleNode

    def initialize( name, super_node )
      super name
      @superclass = super_node
    end

    def ancestors
      (super() + (@superclass ? @superclass.ancestors : [])).uniq
    end

  end

end
