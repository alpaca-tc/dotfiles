echo "Hello $USER\n"

# シンボリックの生成
read -p "Install dotfiles? y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    DOT_FILES=(.gitignore_global .ctags .dir_colors .gemrc .gitconfig .inputrc .rspec .rvmrc .tmux.conf .tmux.split .zshrc .autojump .emacs.d .tmuxinator .vim .zsh local .pryrc .eskk .eskk_dict .tmux-powerlinerc .tmux .rubocop.yml .watsonrc .irbrc .editrc)

    echo "...install dotfiles...\n"
    for file in ${DOT_FILES[@]}
    do
        if [ -a $HOME/$file ]; then
            echo "exists: ~/$file"

            if [ "$yn" != "a" ]; then
                read -p "override? y/n/a " yn
            fi
        else
            if [ $yn != "a" ]; then
                export yn=y
            fi
        fi

        if [ $yn = "y" -o $yn = "Y" -o $yn = "a" ]; then
            rm -rf $HOME/$file
            ln -s `pwd`/$file $HOME/$file
            echo "done!: ~/$file"
        fi
    done

    DOT_FILES=(.bundle)
    # viで使用するフォルダ生成
    for file in ${DOT_FILES[@]}
    do
        echo "...create folder: ~/$file"
        mkdir -p $HOME/$file
    done

    ln -s $HOME/.vim $HOME/.nvim
    mkdir -p $HOME/.config/nvim
    ln -s $HOME/.vim $HOME/.config/nvim
fi

# finderで隠しファイルを表示する
read -p "Show hidden files? y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    defaults write com.apple.finder AppleShowAllFiles TRUE
    echo "done!!"
    echo "...restart finder\n"
    killall Finder
fi

read -p "Never create .DS_Store? y/n" yn
if [ $yn = "y" -o $yn = "Y" ]; then
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    echo "...success"
fi

# default shell を変更
read -p "Change default shell? zsh y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    chsh -s /usr/local/bin/zsh
    echo "done!!"
fi

# 秘密鍵を生成して、githubから残りのファイルをDLする
echo "Install .ssh and .memolist from github?"
read -p "--notice-- remove ~/.ssh y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    echo "...Remove .ssh directory"
    rm -rf ~/.ssh
    mkdir -p ~/.ssh
    git clone https://github.com/alpaca-tc/secret.git
    chmod +x `pwd`/secret/setup.sh
    echo "...run secret setup.sh \n"
    `pwd`/secret/setup.sh
else
    mkdir ~/.memolist
    echo "~/.memolistを生成しました"
fi
