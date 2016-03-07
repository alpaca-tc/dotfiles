# 環境変数
# # {{{
export SHELL=/usr/local/bin/zsh-5.2
export EDITOR=vim
export GIT_EDITOR=/usr/local/bin/vim
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
# }}}

# PATH
# {{{
export PATH=''
export MANPATH=''
export MANPATH=$MANPATH:/usr/share/man
export PATH=/bin:/sbin:/usr/sbin:/usr/bin

# zsh関連
export PATH=$HOME/.autojump/bin:$PATH

# zsh関連
export PATH=$HOME/bin:$PATH

# powerline
export PATH=$HOME/.bundle/powerline/scripts:$PATH

# rsense
export RSENSE_HOME=$HOME/.bundle/rsense-0.3

# node
export PATH=./node_modules/.bin:$PATH
export NODE_PATH=/usr/local/lib/node
export NODE_PATH=/usr/local/lib/node_modules:$NODE_PATH
export NODE_PATH=/usr/local/lib/jsctags:${NODE_PATH}
export PATH=/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH

# homebrew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export MANPATH=/usr/local/share/man:$MANPATH

# java 1.7.0
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_07.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH
# export CLASSPATH=$JAVA_HOME'/lib/ext'

# scala 2.9
export SCALA_HOME=/usr/local/Cellar/scala/2.9.2

# Golang 1.2.1
# export GOROOT=`go env GOROOT`
# export GOPATH=$HOME/.go
# export PATH=$PATh:$GOROOT/bin:$GOPATH/bin:$PATH

# rbenv
if [ -d '/usr/rbenv' ];then
  export RBENV_ROOT=/usr/rbenv
  export PATH=/usr/rbenv/bin:$PATH
else
  export PATH=$HOME/.rbenv/bin:$PATH
  export PATH=$PATH:./bin
fi

eval "$(rbenv init -)"

# Vagrant
export PATH=/Applications/Vagrant/bin:$PATH

# MacVim
export PATH=/Applications/MacVim.app/Contents/MacOS:$PATH

# setup_rails_application
export PATH=$HOME/dotfiles/bin:$PATH

# scala
[[ -s "$HOME/.bundle/ensime" ]] && export PATH=$HOME/.bundle/ensime/lib_2.9.2:$PATH

# python
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"

# export PYTHONPATH=/usr/local/Cellar/python32/3.2.3/Frameworks/Python.framework/Versions/3.2
# alias python=python3.2
export PATH=$PATH:$HOME/usr/binl

# QT
export PATH=/usr/local/Trolltech/Qt-4.8.6/bin:$PATH
# }}}

fpath=( $HOME/dotfiles/.zsh/zsh-completions/src $HOME/.zsh/site-functions $fpath)

# For rust
export PATH=$PATH:/usr/local/bin/bin

# For neovim
export PATH=$HOME/neovim/bin:$PATH

# For watson
export LESS="-R"

# 各種読み込み
# {{{
source ~/.zsh/.zshrc.basic
source ~/.zsh/.zshrc.prompt
source ~/.zsh/.zshrc.extends
source ~/.zsh/.zshrc.alias
source ~/.zsh/.zshrc.smartalias
source ~/.zsh/.zshrc.bindkey
# }}}
