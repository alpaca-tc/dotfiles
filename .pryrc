# coding: utf-8

# ininialize alias
command_alias = {
  "show" => "show-method",
  "c" => "continue",
  "s" => "step",
  "n" => "next",
}
command_alias.each do |k, v|
  Pry.config.commands.alias_command k, v
end
Pry.config.editor="vim"

# デフォルトがださいのでカスタマイズprompt
def get_prompt (target_self, nest_level, pry)
  space_string = " "
  nest_string  = "‣"

  nest =  ""
  0.upto( nest_level ) { nest += nest_string  }                 #=> "‣‣‣"
  klass_or_module = Pry.view_clip(target_self) + space_string * 10 #=> "String     "
  nest = nest + space_string * 10

  sprintf( "\e[33;1m%.10s \e[36;5m%.4s\e[0m ", klass_or_module, nest)
end

Pry.config.prompt = [
  proc { |target_self, nest_level, pry|
    get_prompt(target_self, nest_level, pry)
  },

  proc { |target_self, nest_level, pry|
    get_prompt(target_self, nest_level, pry)
  }
]

# hirbをpryに対応させる
def hirb_hack
  Pry.config.print = proc do |output, value|
    Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value)
  end
end

# Hirbをdefaultで使う場合は以下をコメントイン
def hirb_enable
  require 'hirb'
  Hirb.enable
end
hirb_enable
