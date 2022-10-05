# source ~/.zsh/git-completion.bash
source ~/.zsh/.zshrc

if [ -e ~/.envrc ]; then
  source ~/.envrc
fi

export PATH="$HOME/.yarn/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/src/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/src/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/src/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/src/google-cloud-sdk/completion.zsh.inc"; fi
