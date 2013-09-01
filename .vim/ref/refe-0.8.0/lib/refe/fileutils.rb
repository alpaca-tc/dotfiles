#
# fileutils.rb
#
# Copyright (c) 2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

module ReFe

  module FileUtils

    def mkdir_p( path )
      dir = File.expand_path(path)
      stack = []
      until FileTest.directory?(dir)
        stack.push dir
        dir = File.dirname(dir)
      end
      stack.reverse_each do |n|
        Dir.mkdir n
      end
    end
  
  end

end
