
require 'refe/completiontable'

class CompletionTableTester < RUNIT::TestCase

  testme!

  def setup
    @table = ReFe::CompletionTable.new('data/comptable', false)
    @all = File.readlines('data/comptable').map {|n| n.strip }
  end

  def test_s_new
    assert_instance_of ReFe::CompletionTable, @table
  end

  def test_inspect
    assert_equal @table.inspect, '#<ReFe::CompletionTable path=data/comptable>'
  end

  def test_list
    assert_equal @all, @table.list.sort
  end

  def test_expand
    assert_equal @all, @table.expand(//)
    assert_equal %w(aaa), @table.expand(/a/)
  end

  def test_add
    assert_exception(ArgumentError) {
        @table.add 'tmp'
    }

    File.unlink 'data/tmp' if File.exist?('data/tmp')
    table = ReFe::CompletionTable.new('data/tmp', true)
    table.add 'aaa'
    table.add 'bbb'
    table.add 'ccc'
    assert_equal %w(aaa bbb ccc), table.list
    table.flush

    table = ReFe::CompletionTable.new('data/tmp', false)
    assert_equal %w(aaa bbb ccc), table.list

    table = ReFe::CompletionTable.new('data/tmp', true)
    assert_equal %w(aaa bbb ccc), table.list

    File.unlink 'data/tmp'
  end

end
