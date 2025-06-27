is_executable() {
  type "$1" &> /dev/null;
}

# PATH
# {{{
export PATH=''
export MANPATH=''
export MANPATH=$MANPATH:/usr/share/man
export PATH=/usr/local/bin:/bin:/sbin:/usr/sbin:/usr/bin

# zsh関連
export PATH=$HOME/.autojump/bin:$PATH

# zsh関連
export PATH=$HOME/bin:$PATH

# user関連
export PATH=$HOME/usr/bin:$PATH

# yarn
export PATH="$HOME/.yarn/bin:$PATH"

# homebrew
if [ -x '/opt/homebrew/bin/brew' ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# bison
export PATH="/opt/homebrew/opt/bison/bin:$PATH"

# sphinx
export PATH="/opt/homebrew/opt/sphinx-doc/bin:$PATH"

if [ -x '/usr/local/bin/brew' ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export CPPFLAGS=""

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib -L/opt/homebrew/opt/openssl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include -I/opt/homebrew/opt/openssl/include"

# iTerm2
export PATH=$HOME/usr/bin:$HOME/opt/homebrew/bin:$PATH

# gcloud
export PATH=$HOME/src/google-cloud-sdk/bin:$PATH

# dotnet
export PATH=$HOME/.dotnet:$PATH

# java 1.7.0
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_07.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH
# export CLASSPATH=$JAVA_HOME'/lib/ext'
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# scala 2.9
export SCALA_HOME=/opt/homebrew/Cellar/scala/2.9.2

# XCode
export PATH=/Library/Apple/usr/bin:$PATH

export LDFLAGS=""

if [ -d '/opt/homebrew/opt/readline' ]; then
  export LDFLAGS="-L/opt/homebrew/opt/readline/lib ${LDFLAGS}"
  export CPPFLAGS="-I/opt/homebrew/opt/readline/include ${CPPFLAGS}"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
fi

if [ -d '/opt/homebrew/Cellar/zstd' ]; then
  export LIBRARY_PATH=$LIBRARY_PATH:$(brew --prefix zstd)/lib/
fi

if [ -d '/opt/homebrew/opt/icu4c/lib/pkgconfig' ]; then
  export LDFLAGS="-L/opt/homebrew/opt/icu4c/lib ${LDFLAGS}"
  export CPPFLAGS="-I/opt/homebrew/opt/icu4c/include ${CPPFLAGS}"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
fi

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
  export C_INCLUDE_PATH=$HOME/.rbenv/versions/3.2.3/include/ruby-3.2.0:$C_INCLUDE_PATH
  export RUBY_DEBUG_LOG_LEVEL=FATAL
fi

# rust
if [ -d "$HOME/.cargo" ];then
  source $HOME/.cargo/env
fi

# nodenv
export PATH=$HOME/.nodenv/bin:$PATH

if is_executable nodenv; then
  eval "$(nodenv init -)"
fi

# node
export PATH=./node_modules/.bin:$PATH

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH

if is_executable pyenv; then
  eval "$(pyenv init -)"
  export PATH=$HOME/.local/bin:$PATH
  export CPPFLAGS="$(python3-config --includes) $(python3-config --includes | sed -E 's@([^ ]+)@\1/cpython@g') ${CPPFLAGS}"
fi

# goenv
export PATH=$PATH:$HOME/.goenv/bin

if is_executable goenv; then
  eval "$(goenv init -)"
  export GO111MODULE=on
  export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
fi

if is_executable direnv; then
  eval "$(direnv hook zsh)"
fi

# exenv
export PATH=$HOME/.exenv/bin:$PATH

if is_executable exenv; then
  eval "$(exenv init -)"
fi

# tfenv
export PATH=$HOME/.tfenv/bin:$PATH

# Vagrant
export PATH=/Applications/Vagrant/bin:$PATH
export DOCKER_MF_DEV_VOLUME_OPTION=:cached

# MacVim
export PATH=/Applications/MacVim.app/Contents/MacOS:$PATH

# setup_rails_application
export PATH=$HOME/dotfiles/bin:$PATH
export RAILS_SYSTEM_TESTING_SCREENSHOT=inline

# scala
[[ -s "$HOME/.bundle/ensime" ]] && export PATH=$HOME/.bundle/ensime/lib_2.9.2:$PATH

# python
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"

# export PYTHONPATH=/opt/homebrew/Cellar/python32/3.2.3/Frameworks/Python.framework/Versions/3.2
# alias python=python3.2
export PATH=$PATH:$HOME/usr/bin
# }}}

fpath=( $HOME/dotfiles/.zsh/zsh-completions/src $HOME/.zsh/site-functions $fpath)

# # {{{
if is_executable nvim; then
  export EDITOR=nvim
  export GIT_EDITOR=nvim
fi

if is_executable git; then
  export PATH=$PATH:/opt/homebrew/share/git-core/contrib/diff-highlight:/usr/local/share/git-core/contrib/diff-highlight/
fi

if is_executable direnv; then
  eval "$(direnv hook zsh)"
fi

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export TZ=Asia/Tokyo
# }}}

# For neovim
# export PATH=$HOME/src/neovim/build/bin:$PATH
# export VIMRUNTIME=/opt/homebrew/share/vim/vim80

# For watson
export LESS="-R"

# For SSL
export SSL_CERT_FILE=$HOME/dotfiles/cacert.pem

# For Sublime
export PATH=$PATH:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin

# https://shinkufencer.hateblo.jp/entry/2019/05/02/000000_1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# 各種読み込み
# {{{
source ~/.zsh/.zshrc.basic
source ~/.zsh/.zshrc.prompt
source ~/.zsh/.zshrc.extends
source ~/.zsh/.zshrc.alias
source ~/.zsh/.zshrc.smartalias
source ~/.zsh/.zshrc.bindkey

[[ -s "$HOME/.secret.zshrc" ]] && source ~/.secret.zshrc
# }}}
