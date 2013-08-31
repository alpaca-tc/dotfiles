
require 'refe/database'


class MethodCompletionTester < RUNIT::TestCase

  testme!

  include ReFe::MethodCompletion

  def setup
    @main_table ||= AlwaysDifferent.new
    @comp_table ||= ReFe::CompletionTable.new('data/method_comp', false)
    @all ||= File.readlines('data/method_comp').map {|n| n.strip }.sort
  end

  class AlwaysDifferent
    def initialize
      @value = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    end

    def []( *key )
      @value.succ!
      @value
    end
  end

  def complete( c, t, m )
    list = complete0(@main_table, @comp_table, c, t, m)
    assert_instance_of Array, list
    assert_equal false, (list.size == 0), "list.size == 0"
    list.sort
  end


  def test_capital
    assert_equal %w(
        Kernel#String
        ).sort,
        complete(nil, nil, 'String')
  end

  def test_empty_string
    assert_equal @all, complete('', nil, '')
  end

  def test_nil
    assert_equal @all, complete(nil, nil, nil)
  end

  def test_exact_match
    assert_equal %w(
        Process.waitpid
        ).sort,
        complete(nil, nil, 'waitpid')
    assert_equal %w(
        File.chmod
        ).sort,
        complete('File', '.', 'chmod')
    assert_equal %w(
        File.chmod
        ).sort,
        complete('file', '.', 'chmod')
    assert_exception(ReFe::CompletionError) {
        complete('File', '.', 'Chmod')
    }
  end

  def test_ignore_case
    assert_equal %w(
        ENV#each ENV#each_key ENV#each_pair ENV#each_value ENV#empty?
        Enumerable#each_with_index Enumerable#entries
        Exception#exception Exception.exception
        ).sort,
        complete('e', nil, 'e')
    assert_equal %w(
        Exception.exception
        ).sort,
        complete('e', '.', 'e')
    assert_equal %w(
        ENV#each ENV#each_key ENV#each_pair ENV#each_value ENV#empty?
        Enumerable#each_with_index Enumerable#entries
        Exception#exception
        ).sort,
        complete('e', '#', 'e')

    assert_equal %w(
        Socket.getaddrinfo Socket.gethostbyaddr Socket.gethostbyname
        Socket.gethostname Socket.getnameinfo Socket.getservbyname
        String#gsub String#gsub!
        StringIO#getc StringIO#gets
        StringScanner#get_byte StringScanner#getch
        Super#getacl Super#getquota Super#getquotaroot Super#greeting
        ).sort,
        complete('s', nil, 'g')
    assert_equal %w(
        String#gsub String#gsub!
        StringIO#getc StringIO#gets
        StringScanner#get_byte StringScanner#getch
        Super#getacl Super#getquota Super#getquotaroot Super#greeting
        ).sort,
        complete('s', '#', 'g')
    assert_equal %w(
        Socket.getaddrinfo Socket.gethostbyaddr Socket.gethostbyname
        Socket.gethostname Socket.getnameinfo Socket.getservbyname
        ).sort,
        complete('s', '.', 'g')
  end

  def test_suffix
    assert_equal %w(
        String#gsub!
        ).sort,
        complete('s', nil, 'g!')
    assert_equal %w(
        String#gsub!
        ).sort,
        complete('s', '#', 'g!')
    assert_exception(ReFe::CompletionError) {
        complete('s', '.', 'g!')
    }

    assert_equal %w(
        String#empty?  String#include?
        StringIO#closed?  StringIO#closed_read?  StringIO#closed_write?
        StringIO#eof?  StringIO#tty?
        StringScanner#eos?  StringScanner#match?  StringScanner#matched?
        Super#multipart?
        Sync_m.exclusive?  Sync_m.locked?  Sync_m.shared?
        Sync_m.sync_exclusive?  Sync_m.sync_locked?  Sync_m.sync_shared?
        Syslog#opened?
        ).sort,
        complete('s', nil, '?')
    assert_equal %w(
        String#empty?  String#include?
        StringIO#closed?  StringIO#closed_read?  StringIO#closed_write?
        StringIO#eof?  StringIO#tty?
        StringScanner#eos?  StringScanner#match?  StringScanner#matched?
        Super#multipart?
        Syslog#opened?
        ).sort,
        complete('s', '#', '?')
    assert_equal %w(
        Sync_m.exclusive?  Sync_m.locked?  Sync_m.shared?
        Sync_m.sync_exclusive?  Sync_m.sync_locked?  Sync_m.sync_shared?
        ).sort,
        complete('s', '.', '?')

    assert_equal %w(
        String#include?
        ).sort,
        complete('s', nil, 'i?c?')
  end

  def test_metachar_Q
    assert_equal %w(
        Array#include?
        Curses::Window#inch
        DBM#include?
        ENV#include?
        Enumerable#include?
        GDBM#include?
        Hash#include?
        IO#ioctl
        Included#include?
        Module#include Module#include?  Module#included Module#included_modules
        OptionParser.inc
        Precision.included
        String#include?
        ).sort,
        complete(nil, nil, 'i?c')
    assert_equal %w(
        Array#include?
        DBM#include?
        ENV#include?
        Enumerable#include?
        GDBM#include?
        Hash#include?
        Included#include?
        Module#include?
        String#include?
        ).sort,
        complete(nil, nil, 'i?c?')
  end

  def test_metachar_ASTER
    assert_equal %w(
        Array#include?  Array#index Array#indexes Array#indices
        Class#inherited DBM#include?  DBM#indexes DBM#indices
        ENV#include?  ENV#index ENV#indexes ENV#indices
        Enumerable#include?  Fixnum#id2name Float.induced_from
        GDBM#include?  GDBM#index GDBM#indexes GDBM#indices
        Hash#include?  Hash#index Hash#indexes Hash#indices
        Included#include?  Integer.induced_from
        Module#include Module#include?  Module#included Module#included_modules
        Module#instance_method Module#instance_methods
        Object#id Precision.included Precision.induced_from
        String#include?  String#index Symbol#id2name Syslog#ident
        Time#isdst
        ).sort,
        complete(nil, nil, 'i*d')
    assert_equal %w(
        Array#assoc Class#allocate Curses::Window#addch Math.acos
        Math.acosh Module#ancestors Module#attr_accessor
        Net::FTP#acct Net::HTTP#active? Net::POP3#active?
        Net::SMTP#active? OptionParser.accept
        OptionParser::List#accept Socket#accept Super#authenticate
        Super.add_authenticator TCPServer#accept
        Thread#abort_on_exception Thread#abort_on_exception=
        Thread.abort_on_exception Thread.abort_on_exception=
        Time#asctime UNIXServer#accept
        ).sort,
        complete(nil, nil, 'a*c')
    assert_equal %w(
        Time#asctime
        ).sort,
        complete(nil, nil, 'a*sc')
  end

  def test_notfound
    assert_exception(ReFe::CompletionError) {
        complete('xxxxxx', nil, 'xxxxxxxxx')
    }
    assert_exception(ReFe::CompletionError) {
        complete('AAA', nil, 'AAA')
    }
  end

  def test_wrong_argument
    assert_exception(ArgumentError) {
        complete('x', 'AAAAAAAAAAAAAA', 'x')
    }
    assert_exception(ArgumentError) {
        complete('x', '', 'x')
    }
  end

end
