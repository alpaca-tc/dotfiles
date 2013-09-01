#!/usr/bin/env ruby
#
# execute unit tests in test/
#

require 'runit/testsuite'
require 'runit/testcase'
require 'runit/cui/testrunner'


TESTDIR = 'test'

def main
  Dir.chdir TESTDIR unless File.basename(Dir.pwd) == TESTDIR
  unless /Test::Unit/ === RUNIT::CUI::TestRunner.superclass.name
    RUNIT::CUI::TestRunner.quiet_mode = true
  end
  RUNIT::CUI::TestRunner.new.run load_test_suite(ARGV)
end


def load_test_suite( specs )
  specs.empty?() ? load_all_test_cases() :
                   load_selected_test_cases(specs)
end


def load_all_test_cases
  suite = RUNIT::TestSuite.new
  Dir.glob('test*.rb').each do |fname|
    load_test_classes(fname).each do |c|
      suite.add_test c.suite
    end
  end
  suite
end


def load_selected_test_cases( specs )
  suite = RUNIT::TestSuite.new
  specs.each do |spec|
    suite.add_test get_suite( * parse_target_spec(spec) )
  end
  suite
end

def parse_target_spec( arg )
  m = %r<\A(\w+)(?:/(\w+)(?:\.(\w+(?:,\w+)*))?)?>.match(arg) or
                                          fail "wrong arg format: #{arg}"
  return m[1], m[2], m[3] && m[3].split(/,/)
end

def get_suite( t_file, t_class, t_methods )
  suite = RUNIT::TestSuite.new
  
  classes = load_test_classes("test#{t_file}.rb")
  if t_class
    targclass = find_target_class(t_file, classes, t_class)
    if t_methods
      t_methods.each do |m|
        suite.add_test targclass.new('test_' + m)
      end
    else
      suite.add_test targclass.suite
    end
  else
    classes.each do |c|
      suite.add_test c.suite
    end
  end

  suite
end

def find_target_class( t_file, classes, target )
  find_target_class_0(classes, target) or
          fail "no such class in test#{t_file}.rb: #{target}Tester"
end

def find_target_class_0( classes, target )
  classes.find {|c|
      c.name.split(/::/)[-1].downcase == target.downcase + 'tester'
  }
end


$loaded_test_classes = []

def load_test_classes( fname )
  fail "test script '#{fname}' not exist" unless File.file? fname

  require './' + fname
  fail "Error: #{fname} does not contains any test classes; abort."\
          if $loaded_test_classes.empty?

  ret, $loaded_test_classes = $loaded_test_classes, []
  ret
end

class Module
  def testme!
    fail "testme! must be called only for Class: #{self.name} is a Module"
  end
end
class Class
  def testme!
    fail "class '#{self.name}' is not a RUNIT::TestCase"\
                                    unless self < RUNIT::TestCase
    $loaded_test_classes.push self
  end
end


def fail( msg, status = 1 )
  $stderr.puts msg
  exit status
end


main
