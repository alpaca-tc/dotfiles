# coding: utf-8

require 'rubygems'
require 'hirb'
require 'pry'

# Hirb hack
module PrySetting
  SPACE = " "
  NEST  = "‣"

  # hirbをpryに対応させる
  def self.hirb_hack
    Pry.config.print = proc do |output, value|
      Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value)
    end
  end

  # Hirbをdefaultで使う場合は以下をコメントアウト
  def self.hirb_enable
    Hirb.enable
    p "Hirb.enabled"
  end


  # change default color
  # colors #=> { symbol: '1;37' }
  def self.set_color(colors)
    def Pry.set_color sym, color
      CodeRay::Encoders::Terminal::TOKEN_COLORS[sym] = color.to_s
      { sym => color.to_s }
    end


    colors.each do |syntax, color|
      Pry.set_color syntax, color
    end
  end

  # デフォルトがださいのでカスタマイズprompt
  def self.get_prompt (target_self, nest_level, pry)
    nest =  ""
    0.upto( nest_level ) do nest += NEST end                 #=> "‣‣‣"
    klass_or_module = Pry.view_clip(target_self) + SPACE * 10 #=> "String     "
    nest = nest + SPACE * 10

    sprintf( "\e[33;1m%.10s \e[36;5m%.3s\e[0m", klass_or_module, nest)
  end

  # デフォルトがださいのでカスタマイズprompt
  def self.pry_prompt
    Pry.config.prompt = [
      proc { |target_self, nest_level, pry|
        get_prompt(target_self, nest_level, pry)
      },

      proc { |target_self, nest_level, pry|
        prmpt = get_prompt(target_self, nest_level, pry)
        "#{' ' * ( prmpt.length / 2 - 2 )}"
      }
    ]
  end

  # plyを使う場合のaliasを作成
  # 環境の設定を追記
  # 自由に変更して
  def self.pry_setting
    Pry.commands.alias_command 'c', 'continue'
    Pry.commands.alias_command 's', 'step'
    Pry.commands.alias_command 'n', 'next'
    Pry.config.editor="vim"
  end

end

PrySetting.pry_setting
PrySetting.pry_prompt
PrySetting.hirb_hack
# PrySetting.hirb_enable
