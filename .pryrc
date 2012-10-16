# coding: utf-8

require 'hirb'

# Hirb hack
Pry.config.print = proc do |output, value|
  Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value)
end
# Hirb.enable
# p "Hirb.enabled"

# set color
# def Pry.set_color sym, color
#   CodeRay::Encoders::Terminal::TOKEN_COLORS[sym] = color.to_s
#   { sym => color.to_s }
# end
# Pry.set_color :integer, '1;37'

# change prompt
def get_prompt (target_self, nest_level, pry)
  nest =  ""
  0.upto( nest_level ) do nest += "‣" end                 #=> "‣‣‣"
  klass_or_module = Pry.view_clip(target_self) + " " * 10 #=> "String     "
  nest = nest + " " * 10

  sprintf( "\e[33;1m%.10s \e[36;5m%.3s\e[0m", klass_or_module, nest)
end

Pry.config.prompt = [
  proc { |target_self, nest_level, pry|
    get_prompt(target_self, nest_level, pry)
  },

  proc { |target_self, nest_level, pry|
    prmpt = get_prompt(target_self, nest_level, pry)
    "#{' ' * ( prmpt.length / 2 - 2 )}"
  }
]

Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'

# vim:ft=ruby:
