#
# mygetopt.rb
#

require 'getoptlong'


class MyGetoptLong < GetoptLong

  class << self
    alias orignew new

    def new( usage, descripter )
      parser = orignew( * [descripter].flatten.map {|line|
          line.strip!
          next if line.empty?
          display, shortopt, longopt, takearg, doc = line.split(/\s+/, 5)
          a = []
          a.push longopt unless longopt == '-'
          a.push shortopt unless shortopt == '-'
          a.push takearg == '-' ?
                 GetoptLong::NO_ARGUMENT : GetoptLong::REQUIRED_ARGUMENT
          a
      }.compact )
      parser.quiet = true
      parser.instance_eval {
        @usage = usage
        @descripter = descripter.strip
      }
      parser
    end
  end

  def usage( status, errmsg = nil )
    f = (status == 0 ? $stdout : $stderr)

    f.puts "#{File.basename $0}: #{errmsg}" if errmsg
    @usage.each do |uline|
      if /%%options%%/ === uline
        print_options f
      else
        f.print uline
      end
    end
    exit status
  end

  def print_options( f )
    @descripter.each do |line|
      line.strip!
      if line.empty?
        f.puts
        next
      end

      disp, sopt, lopt, takearg, doc = line.split(/\s+/, 5)
      if disp == 'o'
        sopt = nil if sopt == '-'
        lopt = nil if lopt == '-'
        opt = [sopt, lopt].compact.join(',')

        takearg = nil if takearg == '-'
        opt = [opt, takearg].compact.join(' ')

        f.printf "  %-27s %s\n", opt, doc
      end
    end
  end

end
