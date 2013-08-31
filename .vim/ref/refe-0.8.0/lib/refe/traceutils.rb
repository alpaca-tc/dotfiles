#
# traceutils.rb
#
# Copyright (c) 2003 Minero Aoki <aamine@loveruby.net>
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2 or later.
#

$REFE_TRACE = false

module ReFe

  module TraceUtils

    def trace( msg )
      $stderr.puts msg if $REFE_TRACE
    end
  
  end

end
