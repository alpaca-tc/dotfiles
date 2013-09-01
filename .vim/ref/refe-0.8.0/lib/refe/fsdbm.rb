#
# fsdbm.rb
#
# Copyright (c) 2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

require 'find'


class FSDBM

  # turn on tracing only when used with refe
  begin
    require 'refe/traceutils'
    include ReFe::TraceUtils
  rescue LoadError
    def trace( msg )
    end
  end

  def initialize( basedir )
    @basedir = basedir
    @base_re = %r<\A#{@basedir}/>
  end

  def []( *keys )
    path = keys_to_path(keys)
    if FileTest.file?(path)
      File.open(path) {|f|
          return f.read
      }
    elsif FileTest.directory?(path)
      return nil unless File.file?(path + '/-')
      File.open(path + '/-') {|f|
          return f.read
      }
    else
      nil
    end
  end

  def []=( *args )
    val = args.pop
    setup_dirs args[0..-2]
    path = keys_to_path(args)
    begin
      # $stderr.puts "Warning: exist: #{path}" if File.file?(path)
      File.open(path, 'w') {|f|
          f.write val
      }
    rescue Errno::EISDIR
      # $stderr.puts "Warning: exist: #{path}/-" if File.file?(path + '/-')
      File.open(path + '/-', 'w') {|f|
          f.write val
      }
    end
    val
  end

  private

  def setup_dirs( dirs )
    return if dirs.empty?

    dir = @basedir.dup
    while d = dirs.shift
      dir << '/' << encode(d)
      begin
        Dir.mkdir(dir) unless FileTest.directory?(dir)
      rescue Errno::EEXIST
        File.rename dir, File.dirname(dir) + "/tmp#{$$}"
        Dir.mkdir dir
        File.rename File.dirname(dir) + "/tmp#{$$}", dir + '/-'
      end
    end
  end

  def keys_to_path( keys )
    @basedir + '/' + keys.map {|n| encode(n) }.join('/')
  end

  def encode( str )
    str.gsub(/[^a-z0-9_]/n) {|ch|
        (/[A-Z]/n === ch) ? "-#{ch}" : sprintf('%%%02x', ch[0])
    }.downcase
  end

  def decode( str )
    str.gsub(/%[\da-h]{2}|-[a-z]/i) {|s|
        (s[0] == ?-) ? s[1,1].upcase : s[1,2].hex.chr
    }
  end

end
