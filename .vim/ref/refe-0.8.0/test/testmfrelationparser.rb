#
# testmfrelationparser.rb
#

require 'refe/mfrelationparser'
begin
  require 'stringio'
rescue LoadError
  require 'mystringio'
  StringIO = StringInput unless defined?(StringIO)
end

class MFRelationParserTester < RUNIT::TestCase

  testme!

  def setup
    @parser = ReFe::MFRelationParser.new
  end

  def test_s_new
    assert_instance_of ReFe::MFRelationParser, @parser
  end

  def test_parse
    src, ok = parse_datafile('data/mtof')
    my = @parser.parse(StringIO.new(src))
    assert_equal ok.keys.sort, my.keys.sort
    ok.each_key do |m|
      assert_equal ok[m], my[m]
    end
  end

  def parse_datafile( fname )
    ok = {}
    src = ''
    File.foreach(fname) do |line|
      case line
      when /\A@@ (\S+) (\S+)/
        ok[$1] = $2
      else
        src << line.sub(/\s+\z/,'') << "\n"
      end
    end
    return src, ok
  end

end
