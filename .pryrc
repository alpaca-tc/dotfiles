module CustomPry
  def self.alias_commands(commands = {})
    commands.each do |new_name, original|
      Pry.config.commands.alias_command(new_name, original) if Pry.config.commands[original]
    end
  end

  class << self
    KLASS_LENGTH = 30
    NEST_STRING = '‣'
    SPACE = ' '

    def extend_prompt
      Pry.config.prompt = [method(:default_prompt), method(:nest_prompt)]
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
end

Pry.config.editor=ENV['EDITOR']

CustomPry.extend_prompt
CustomPry.alias_commands(
  'show' => 'show-method',
  'c' => 'continue',
  's' => 'step',
  'n' => 'next',
)
