Pry.config.editor = ENV['EDITOR']
Pry.config.commands.alias_command('show', 'show-method')

show_backtrace = Class.new(Pry::ClassCommand) do
  IGNORE_PATHS = %w[
    /pry
    /byebug
    /rspec/core
  ].freeze

  match 'show-backtrace'
  description 'Filter the caller locations'

  banner <<-'BANNER'
    Usage: show-backtrace [NUMBER]

    show-backtrace
    show-backtrace 0
  BANNER

  def options(opt)
    opt.on :f, :filter,
      "Filter caller",
      optional_argument: true,
      as: String

    opt.on :i, :index,
      "Line number of backtrace",
      optional_argument: true,
      as: Integer
  end

  def process
    backtrace = filter_backtrace(caller_locations)

    if index_number && backtrace[index_number]
      location = backtrace[index_number]
      edit_file(location)
    else
      show_backtrace(backtrace)
    end
  end

  private

  def show_backtrace(backtrace)
    out = backtrace.map { |location|
      path = Pathname.new(location.path)
      relative_path = relative_path_from_root(path)

      "#{relative_path}:#{location.lineno}:in `#{location.label}`"
    }.map { |line|
      "\e[31m#{line}\e[0m,"
    }.to_a.join("\n")

    _pry_.pager.page(out)
  end

  def filter_re
    Regexp.new(opts[:filter]) if opts.present?(:filter)
  end

  def index_number
    opts[:index] if opts.present?(:index)
  end

  def relative_path_from_root(path)
    if defined?(Rails) && Rails.root
      path.relative_path_from(Rails.root)
    else
      path
    end
  rescue ArgumentError
    path
  end

  def edit_file(location)
    _pry_.run_command("edit #{location.path}:#{location.lineno}")
  end

  def filter_backtrace(backtrace)
    regrexp = ignore_path_re

    # 3で、このファイルのbacktraceを無視する
    backtrace.reject do |location|
      location.path.match?(regrexp)
    end
  end

  def ignore_path_re
    default_re = %r{(?:#{IGNORE_PATHS.join('|')})}

    if filter_re
      Regexp.union(default_re, filter_re)
    else
      default_re
    end
  end
end

require 'date'

class Date
  def inspect
    to_s
  end
end

class ::String
  def sql
    tempfile = Tempfile.new(['sql', '.sql'])
    tempfile.write(self)
    tempfile.rewind
    puts `sqlformat -r -k upper #{tempfile.path}`
  end
end

Pry::Commands.add_command(show_backtrace)
Pry::Commands.alias_command '~', 'show-backtrace'

if Pry::Prompt.respond_to?(:add)
  Pry::Prompt.add(:awesome, 'Awesome prompt') do |context, nesting, pry_instance, sep|
    nest_string = '‣'
    mark = '«'
    space = ' '
    module_name = Pry.view_clip(context)
    nest = nest_string * (nesting + 1)
    format("\e[33;1m%-30.30s \e[36;5m%-4.4s\e[0m #{mark} ", module_name, nest)
  end

  Pry.config.prompt = Pry::Prompt[:awesome]
end
