#
# completiontable.rb
#
# Copyright (c) 2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

require 'refe/traceutils'

module ReFe

  class CompletionTable

    include TraceUtils

    def initialize( path, writeok = false )
      @path = path
      @writeok = writeok
      begin
        @list = File.readlines(path).map {|line| line.strip }
      rescue Errno::ENOENT
        @list = []
      end
    end

    attr_reader :path

    def inspect
      "\#<#{self.class} path=#{@path}>"
    end

    def list
      @list.dup
    end

    def expand( re )
      trace "comp: pattern = #{re.inspect}"
      results = @list.select {|item| re === item }
      if results.size < 20
        trace "comp: results = #{results.join(' ')}"
      else
        trace "comp: results = (too many candidates: #{results.size})"
      end
      results
    end

    def add( item )
      raise ArgumentError, 'database is not writable' unless @writeok
      @list.push item
    end
    
    def flush
      raise ArgumentError, "database is readonly: path=#{@path}" unless @writeok
      begin
        File.open("#{@path}_tmp#{$$}", 'w') {|f|
          @list.uniq.sort.each do |i|
            f.puts i
          end
        }
        File.rename "#{@path}_tmp#{$$}", @path
      rescue
        begin
          File.unlink "#{@path}_tmp#{$$}"
        rescue Errno::ENOENT
          ;
        end
      end
    end
  
  end

end
