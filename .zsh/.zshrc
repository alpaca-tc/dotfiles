# 環境変数
# # {{{
export EDITOR=vim
export GIT_EDITOR=/usr/local/bin/vim
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
# export SHELL=/usr/local/bin/zsh
export BROWSER=google-chrome
# export ARCHFLAGS="-arch x86_64"
# export APXS2=/usr/sbin/apxs
export GITHUB_HOST='github.com'
export CONFIGURE_OPTS="--with-gcc=clang"
export ECLIPSE_HOME='/Applications/eclipse'
export SSL_CERT_FILE=/usr/local/etc/cacert.pem

# 各種の設定 古いgccを使う場合
# export CC='/usr/local/bin/gcc-4.2'
# alias gcc='/usr/local/bin/gcc-4.5'
# }}}

# rbenvの設定
export CPPFLAGS="-I/usr/local/Cellar/readline/6.2.4/include"
export LDFLAGS="-L/usr/local/Cellar/readline/6.2.4/lib"

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
export NODE_PATH=/usr/local/lib/node
export PATH=/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH

# XAMPP
export PATH=/Applications/XAMPP/xamppfiles/bin:$PATH

# homebrew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export MANPATH=/usr/local/share/man:$MANPATH

# java 1.7.0
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_07.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=$JAVA_HOME'/lib/ext'

# scala 2.9
export SCALA_HOME=/usr/local/Cellar/scala/2.9.2

# rbenv
export PATH=$HOME/.rbenv/bin:$HOME/.rbenv:$PATH
eval "$(rbenv init -)"

# MacVim
export PATH=/Applications/MacVim.app/Contents/MacOS:$PATH

# scala
[[ -s "$HOME/.bundle/ensime" ]] && export PATH=$HOME/.bundle/ensime/lib_2.9.2:$PATH

# python
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"

# export PYTHONPATH=/usr/local/Cellar/python32/3.2.3/Frameworks/Python.framework/Versions/3.2
# alias python=python3.2
# }}}

# for vim
# export DYLD_FORCE_FLAT_NAMESPACE=1 
# export DYLD_INSERT_LIBRARIES=/Users/taichou/.pythonbrew/pythons/Python-2.7.2/lib/libpython2.7.dylib


# http://stackoverflow.com/questions/13942443/error-installing-rmagick-on-mountain-lion

fpath=( $HOME/dotfiles/.zsh/zsh-completions/src $HOME/.zsh/site-functions $fpath)

# 各種読み込み
# {{{
source ~/.zsh/.zshrc.basic
source ~/.zsh/.zshrc.prompt
source ~/.zsh/.zshrc.extends
source ~/.zsh/.zshrc.alias
source ~/.zsh/.zshrc.bindkey
# source ~/.zsh/.zshrc.tmuxauto
# source ~/.zsh/.zshrc.command
# }}}
