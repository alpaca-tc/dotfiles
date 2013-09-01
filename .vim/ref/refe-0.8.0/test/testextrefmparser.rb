#
# tesetextrefmparser.rb
#

require 'refe/extrefmparser'
require 'refe/lineinput'
begin
  require 'stringio'
rescue LoadError
  require 'mystringio'
  StringIO = StringInput unless defined?(StringIO)
end

$KCODE = 'EUC'

class ExtentionAPIReferenceManualParserTester < RUNIT::TestCase

  testme!

  def setup
    @parser = ReFe::ExtentionAPIReferenceManualParser.new
  end

  def test_s_new
    assert_instance_of ReFe::ExtentionAPIReferenceManualParser, @parser
  end

  def test_parse
    src, ok = parse_testdata('data/extrefm')
    my = @parser.parse(StringIO.new(src))
    assert_equal ok.keys.sort, my.keys.sort
    my.each do |name, doc|
      assert_equal name, ok.key?(name) ? name : nil
      assert_equal ok[name], doc
    end
  end

  def parse_testdata( fname )
    ok = {}
    src = ''
    File.open(fname) {|f|
      f = LineInput.new(f)
      while line = f.gets
        case line
        when /\A@@@@@src (\S+)/
          f.until_match(/\A@@@@@/) do |line|
            src << line.sub(/\s+\z/,'') << "\n"
          end
        when /\A@@@@@ok (\S+)/
          entname = $1
          buf = ''
          f.until_match(/\A@@@@@/) do |line|
            buf << line.sub(/\s+\z/,'') << "\n"
          end
          ok[entname] = buf
        else
          raise 'bug'
        end
      end
    }

    return src, ok
  end

end
