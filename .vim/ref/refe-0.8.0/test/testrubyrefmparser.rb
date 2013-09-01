#
# testrubyrefmparser.rb
#

require 'refe/rubyrefmparser'

class File
  def file
    self
  end
end

$KCODE = 'EUC'

class RubyReferenceManualParserTester < RUNIT::TestCase

  testme!

  def setup
    @parser = ReFe::RubyReferenceManualParser.new
  end

  def test_s_new
    assert_instance_of ReFe::RubyReferenceManualParser, @parser
  end

  def test_parse
    ok = read_parsed('data/rubyrefm.ok')
    classes, methods = File.open('data/rubyrefm') {|f| @parser.parse(f) }
    # check_classes classes
    check_methods ok, methods
  end
  
  def check_methods( ok, result )
    assert_instance_of Hash, result
    assert_equal ok.size, result.size
    assert_equal ok.keys.sort, result.keys.sort
    ok.keys.sort.each do |k|
      compare_hash ok[k], result[k]
    end
  end

  def compare_hash( ok, result )
    assert_instance_of Hash, result
    assert_equal ok.keys.sort, result.keys.sort
    ok.keys.sort.each do |k|
      assert_equal ok[k], result[k]
    end
  end

  def read_parsed( fname )
    table = nil
    File.open(fname) {|f|
        table = eval(f.read)
    }
    table.each do |key, val|
      val.replace do_split(val)
    end
    table.keys.map {|c| c.sub(/[#\.]\z/, '') }.uniq.each do |cname|
      table[cname + '.'] ||= {}
      table[cname + '#'] ||= {}
    end
    table
  end

  def do_split( old )
    new = {}
    old.each do |key, val|
      key.split(/,/).each do |k|
        new[k] = val
      end
    end
    new
  end

end
