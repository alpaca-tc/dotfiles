#
# testrubysrcparser.rb
#

require 'refe/rubysrcparser'
require 'refe/lineinput'
begin
  require 'stringio'
rescue LoadError
  require 'mystringio'
  StringIO = StringInput unless defined?(StringIO)
end

$KCODE = 'EUC'

class RubySourceCodeParserTester < RUNIT::TestCase

  testme!

  def setup
    @parser = ReFe::RubySourceCodeParser.new
  end

  def test_s_new
    assert_instance_of ReFe::RubySourceCodeParser, @parser
  end

  def test_parse
    src, ok = parse_datafile('data/rubysrc')
    my = @parser.parse(StringIO.new(src))
    assert_instance_of Hash, my
    assert_equal ok.keys.sort, my.keys.sort
    ok.each_key do |name|
      header, body, lineno = ok[name]
      h,      b,    l      = my[name]
      assert_not_nil h
      assert_not_nil b
      assert_not_nil l
      assert_equal header, h
      assert_equal body,   b
      assert_equal lineno, l
    end
  end

  def parse_datafile( fname )
    ok = {}
    src = ''
    lineno = 1

    File.open(fname) {|f|
      f = LineInput.new(f)
      while line = f.gets
        case line
        when /\A@@@@@begin (\S+)/
          fname = $1
          lineno_save = lineno
          header = ''
          f.until_terminator(/\A@@@@@body/) do |line|
            header << line
            src << line
            lineno += 1
          end
          body = ''
          f.until_terminator(/\A@@@@@end/) do |line|
            body << line
            src << line
            lineno += 1
          end
          ok[fname] = [header, body, lineno_save]
        else
          src << line
          lineno += 1
        end
      end
    }

    return src, ok
  end

end
