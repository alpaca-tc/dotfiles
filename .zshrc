# source ~/.zsh/git-completion.bash
source ~/.zsh/.zshrc
[[ -s "${HOME}/.pythonbrew/etc/bashrc" ]] && source $HOME/.pythonbrew/etc/bashrc
export PATH="$HOME/.rbenv/bin/:$HOME/.rbenv:$PATH"
eval "$(rbenv init -)"
