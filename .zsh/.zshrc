is_executable() {
  type "$1" &> /dev/null;
}

# PATH
# {{{
export PATH=''
export MANPATH='' export MANPATH=$MANPATH:/usr/share/man export PATH=/bin:/sbin:/usr/sbin:/usr/bin

# zsh関連
export PATH=$HOME/.autojump/bin:$PATH

# zsh関連
export PATH=$HOME/bin:$PATH

# user関連
export PATH=$HOME/usr/bin:$PATH

# powerline
export PATH=$HOME/.bundle/powerline/scripts:$PATH

# node
export PATH=./node_modules/.bin:$PATH

# yarn
export PATH="$HOME/.yarn/bin:$PATH"

# homebrew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export MANPATH=/usr/local/share/man:$MANPATH

# iTerm2
export PATH=$HOME/local/bin:$PATH

# java 1.7.0
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_07.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH
# export CLASSPATH=$JAVA_HOME'/lib/ext'
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# scala 2.9
export SCALA_HOME=/usr/local/Cellar/scala/2.9.2

# Golang
export GOPATH=$HOME/.go
export PATH=$PATh:$GOROOT/bin:$GOPATH/bin:$PATH

# rbenv
if [ -d '/usr/rbenv' ];then
  export RBENV_ROOT=/usr/rbenv
  export PATH=/usr/rbenv/bin:$PATH
else
  export PATH=$HOME/.rbenv/bin:$PATH
  export PATH=$PATH:./bin
fi

if is_executable rbenv; then
  eval "$(rbenv init -)"
fi

# nodenv
export PATH=$HOME/.nodenv/bin:$PATH

if is_executable nodenv; then
  eval "$(nodenv init -)"
fi

# pyenv
if is_executable pyenv; then
  eval "$(pyenv init -)"
fi

export PATH=$HOME/.pyenv/bin:$PATH

# exenv
export PATH=$HOME/.exenv/bin:$PATH

if is_executable exenv; then
  eval "$(exenv init -)"
fi

# tfenv
export PATH=$HOME/.tfenv/bin:$PATH

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

# # {{{
if is_executable nvim; then
  export EDITOR=nvim
  export GIT_EDITOR=nvim
fi

if is_executable direnv; then
  eval "$(direnv hook zsh)"
fi

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export TZ=Asia/Tokyo
# }}}

# For rust
export PATH=$PATH:/usr/local/bin/bin

# For neovim
# export PATH=$HOME/src/neovim/build/bin:$PATH
# export VIMRUNTIME=/usr/local/share/vim/vim80

# For watson
export LESS="-R"

# For SSL
export SSL_CERT_FILE=$HOME/dotfiles/cacert.pem

# 各種読み込み
# {{{
source ~/.zsh/.zshrc.basic
source ~/.zsh/.zshrc.prompt
source ~/.zsh/.zshrc.extends
source ~/.zsh/.zshrc.alias
source ~/.zsh/.zshrc.smartalias
source ~/.zsh/.zshrc.bindkey
# }}}
