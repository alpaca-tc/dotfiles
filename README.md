## Setup

### Install applications from browser

- [chrome](https://www.google.com/intl/ja_jp/chrome/)
- [iTerm2](https://iterm2.com)
- [Slack](https://slack.com/intl/ja-jp/downloads/mac?geocode=ja-jp)
- [Docker](https://docs.docker.com/desktop/mac/install/)

### Install applications from App Store

- [1Password](https://apps.apple.com/jp/app/1password-7-password-manager/id1333542190?mt=12)
- [Alfread](https://apps.apple.com/jp/app/alfred/id405843582?mt=12)

### Install applications from Homebrew

- [Homebrew](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# If you use older OS, you need to link /usr/local to /opt/homebrew
# sudo ln -s /usr/local /opt/homebrew

for line in $(cat ./conf/brew.txt)
do 
  brew install $line
done

brew tap universal-ctags/universal-ctags
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
```

### Install dependencies for programming

#### Ruby

```sh
./rbenv_install

# Load rbenv
source ~/.zshrc

rbenv install 3.0.2
rbenv install 2.7.4
rbenv global 3.0.2
```

#### Python

```
./pyenv_install

pyenv install 3.10.0
pyenv install 2.7.18
```

#### Go

```
./goenv_install
```

#### Node

```
./node_install
nodenv install 16.13.0
nodenv global 16.13.0
./node_install
```

#### Rust

```
./rustup_install
```

#### Fonts

```sh
git clone https://github.com/alpaca-tc/alpaca
cd alpaca
git reset --hard HEAD^^^
open fonts
# and Install Ritchy
```

#### Neovim

```
./neovim_install
vi lsp_setup.vim
:source %
```

### Setup hub

Create access token for github

https://github.com/settings/tokens/new

```
---
github.com:
- protocol: https
  user: alpaca-tc
  oauth_token: YOUR_GITHUB_ACCESS_TOKEN
```
