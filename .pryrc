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

Pry.config.prompt = PryConsole.build

## Customize eval line
module FullAccessible
  def method_missing(action, *args, &block)
    return send(action, *args, &block) if respond_to?(action, true)
    super
  end

  Object.prepend(self)
end

## Short Syntax
module ShortSyntax
  def self.format!(str)
    str.gsub!(/\.(@\w+)/, '.instance_variable_get(:\1)')
    str
  end
end

## Evaluate instance variable access
Pry.config.hooks.add_hook(:after_read, :evaluate_instance_variable) do |code, pry|
  ShortSyntax.format!(code)
end

## Evaluate instance variable in the command
Module.new do
  def initialize(str, _pry_, options={})
    ShortSyntax.format!(str)
    super
  end

  Pry::CodeObject.prepend(self)
end
