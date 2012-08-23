export EDITOR=vim
export LANG=ja_JP.UTF-8
export SHELL=/usr/local/bin/zsh
export DOTFILES_DIR=$HOME/dotfiles_serclet
export BROWSER=w3m

# export LESS='-RQM' # R = そのままの制御文字を出力 + 可能なら表示を正しく維持
                   # Q = 完全に quite
                   # M = 詳細なパーセント表示のプロンプト
# ruby
# export RUBYOPT=-Ke

# centOS
# eval $(dircolors -b ~/.dir_colors)

# 各種の設定 古いgccを使う場合
# export CC='/usr/local/bin/gcc-4.2'
# export CC='/usr/bin/gcc-4.2'
# alias gcc='/usr/bin/gcc-4.2'

# alias gcc='/usr/local/bin/gcc-4.2'
export ARCHFLAGS="-arch x86_64"
export APXS2=/usr/sbin/apxs

export PATH=''
export PATH=/bin:/sbin:/usr/sbin:/usr/bin
export MANPATH=$PATH:/usr/share/man

# rvm
# export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
# source "$HOME/.rvm/scripts/rvm"
# fpath=(~/.zsh/Completion $fpath)
# export PATH=$PATH:$GEM_PATH/bin

# XAMPP
export PATH=/Applications/XAMPP/xamppfiles/bin:$PATH

# java 1.7.0
export PATH=/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home/bin:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home
# export CLASSPATH=$JAVA_HOME'/lib/ext'

# rsense
export PATH=$HOME/.vim/ref/rsense-0.3/bin:$PATH
export RSENSE_HOME=$HOME/.vim/ref/rsense-0.3

# homebrew
export PATH=/usr/local/bin:$PATH
export MANPATH=/usr/local/share/man:$MANPATH

# pythonbrew
# export PATH=$PATH:$HOME/.pythonbrew/bin

# vim関連
export PATH=$HOME/local/bin:$HOME/local/sbin:$PATH:
export MANPATH=$HOME/local/man:$MANPATH

# zsh関連
export PATH=$HOME/.autojump/bin:$PATH

# rbenv
# rbenv
export PATH=$HOME/.rbenv/bin:$HOME/.rbenv:$PATH

eval "$(rbenv init -)"

# git
export GITHUB_HOST='github.com'


## alias設定
source ~/.zsh/.zshrc.basic
source ~/.zsh/.zshrc.prompt
source ~/.zsh/.zshrc.extends
source ~/.zsh/.zshrc.alias
# source ~/.zsh/.zshrc.command


