# 環境変数
# # {{{
export EDITOR=vim
export LANG=ja_JP.UTF-8
# export SHELL=/usr/local/bin/zsh
export DOTFILES_DIR=$HOME/dotfiles_serclet
export BROWSER=w3m
export ARCHFLAGS="-arch x86_64"
export APXS2=/usr/sbin/apxs
export GITHUB_HOST='github.com'

# 各種の設定 古いgccを使う場合
# export CC='/usr/local/bin/gcc-4.2'
# alias gcc='/usr/local/bin/gcc-4.5'
# }}}

# PATH
# {{{
export PATH=''
export MANPATH=''
export MANPATH=$MANPATH:/usr/share/man
export PATH=/bin:/sbin:/usr/sbin:/usr/bin

# zsh関連
export PATH=$HOME/.autojump/bin:$PATH

# vim関連
export PATH=$PATH:$HOME/local/bin:$HOME/local/sbin
export MANPATH=$HOME/local/man:$MANPATH

# rsense
export PATH=$HOME/.vim/ref/rsense-0.3/bin:$PATH
export PATH=$PATH:$HOME/.vim/ref/rsense-0.3/bin
export RSENSE_HOME=$HOME/.vim/ref/rsense-0.3

# node
export NODE_PATH=/usr/local/lib/node
export PATH=/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH

# homebrew
export PATH=/usr/local/bin:$PATH
export MANPATH=/usr/local/share/man:$MANPATH

# java 1.7.0
# export PATH=/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home/bin:$PATH
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home
# export CLASSPATH=$JAVA_HOME'/lib/ext'

# rbenv
export PATH=$HOME/.rbenv/bin:$HOME/.rbenv:$PATH
eval "$(rbenv init -)"

# XAMPP
export PATH=/Applications/XAMPP/xamppfiles/bin:$PATH
# }}}

fpath=(~/.zsh/site-functions $fpath)

# 各種読み込み
# {{{
source ~/.zsh/.zshrc.basic
source ~/.zsh/.zshrc.prompt
source ~/.zsh/.zshrc.extends
source ~/.zsh/.zshrc.alias
source ~/.zsh/.zshrc.tmuxauto
# source ~/.zsh/.zshrc.command
# }}}
