Pry.config.editor = ENV['EDITOR']
Pry.config.commands.alias_command('show', 'show-method')

## Customize prompt
class PryConsole
  KLASS_LENGTH = 30
  NEST_STRING = '‣'
  SPACE = ' '

  def self.build
    new.build
  end

  def build
    [method(:default_prompt), method(:nest_prompt)]
  end

  private

  def default_prompt(*args)
    build_prompt(*args, '«')
  end

  def nest_prompt(*args)
    build_prompt(*args, ' ')
  end

  def build_prompt(target_self, nest_level, pry, mark = '*')
    module_name = Pry.view_clip(target_self)
    nest_level += 1
    nest = NEST_STRING * nest_level.to_i
    format("\e[33;1m%-30.30s \e[36;5m%-4.4s\e[0m #{mark} ", module_name, nest)
  end
end

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
  end

  def process
    if input_index && filtered_backtrace[input_index]
      location = filtered_backtrace[input_index]
      edit_file(location)
    else
      show_backtrace
    end
  end

  private

  def show_backtrace
    out = filtered_backtrace.map { |location|
      path = Pathname.new(location.path)
      relative_path = relative_path_from_root(path)

      "#{relative_path}:#{location.lineno}:in `#{location.label}`"
    }.map { |line|
      "\e[31m#{line}\e[0m,"
    }.join("\n")

    _pry_.pager.page(out)
  end

  def filter_re
    Regexp.new(opts.present?(:filter)) if opts.present?(:filter)
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

  def filtered_backtrace
    # 3で、このファイルのbacktraceを無視する
    caller_locations(3).reject do |location|
      location.path =~ ignore_path_re
    end
  end

  def input_index
    arg_string.to_i unless arg_string.empty?
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

Pry::Commands.add_command(show_backtrace)
Pry::Commands.alias_command '~', 'show-backtrace'

Pry.config.prompt = PryConsole.build
