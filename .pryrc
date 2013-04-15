# coding: utf-8

require 'active_support/all'

Pry.config.editor="vim"

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

# デフォルトがださいのでカスタマイズprompt
module Prompt
  mattr_accessor :max_length, :space, :nest_string

  @@klass_length = 20
  @@klass_max_length = 15
  @@max_length = 10
  @@nest_string = "‣"
  @@space = " "

  class << self
    def prompt (target_self, nest_level, pry)
      klass_or_module = fill_blank(Pry.view_clip(target_self), @@klass_length)
      nest_level += 1
      nest = fill_blank(@@nest_string * nest_level.to_i, 5)

      sprintf( "\e[33;1m%s \e[36;5m%s\e[0m « ", klass_or_module, nest)
    end

    private
    def fill_blank(str, length)
      [str, @@space * length].join[0..length]
    end
  end
end

Pry.config.prompt = [
  proc { |target_self, nest_level, pry|
    Prompt.prompt(target_self, nest_level, pry)
  },

  proc { |target_self, nest_level, pry|
    Prompt.prompt(target_self, nest_level, pry)
  }
]

# hirbをpryに対応させる
# def hirb_hack
#   Pry.config.print = proc do |output, value|
#     Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value)
#   end
# end
#
# # Hirbをdefaultで使う場合は以下をコメントイン
# def hirb_enable
#   require 'hirb'
#   Hirb.enable
# end
# hirb_enable
