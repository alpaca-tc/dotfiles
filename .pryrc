Pry.config.editor='vim'

module PryExtender
  COMMAND_ALIAS = {
    'show' => 'show-method',
    'c' => 'continue',
    's' => 'step',
    'n' => 'next',
  }

  class << self
    def command_alias
      COMMAND_ALIAS.each do |short, long|
        Pry.config.commands.alias_command(short, long) if Pry.config.commands[long]
      end
    end

    KLASS_LENGTH = 20
    NEST_STRING = '‣'
    SPACE = ' '

    def extend_prompt
      Pry.config.prompt = [method(:default_prompt), method(:nest_prompt)]
    end

    def default_prompt(*args)
      build_prompt(*args, '«')
    end

    def nest_prompt(*args)
      build_prompt(*args, '*')
    end

    def build_prompt(target_self, nest_level, pry, mark = '*')
      klass_or_module = fill_blank(Pry.view_clip(target_self), KLASS_LENGTH)
      nest_level += 1
      nest = fill_blank(NEST_STRING * nest_level.to_i, 5)

      sprintf("\e[33;1m%s \e[36;5m%s\e[0m#{mark} ", klass_or_module, nest)
    end

    def enable_hirb
      require 'hirb'

      if const_defined?(:Hirb)
        Hirb.enable

        Pry.config.print = proc do |output, value|
          hirb = Hirb::View.view_or_page_output(value)
          hirb || Pry::DEFAULT_PRINT.call(output, value)
        end
      end
    end

    private

    def fill_blank(str, length)
      [str, SPACE * length].join[0..length]
    end
  end
end

# if Pry::VERSION.to_f > 0.9
  PryExtender.command_alias
  PryExtender.extend_prompt
# end
