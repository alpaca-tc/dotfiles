# source ~/.zsh/git-completion.bash
source ~/.zsh/.zshrc

if [ -e ~/.envrc ]; then
  source ~/.envrc
fi

export PATH="$HOME/.yarn/bin:$PATH"
