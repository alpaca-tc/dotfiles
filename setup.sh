# シンボリックの生成

read -p "install dotfiles? y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    DOT_FILES=( .vim .vimrc .ctags .emacs.d .emacs.el .dir_colors .gitconfig .gitignore .inputrc .rsense .tmux.conf .tmux.split .zsh .zshrc local .autojump .zshrc .rspec )

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
        else
            echo "next"
        fi
    done

    DOT_FILES=( .vim.swapfile .bundle .yankring )
    # viで使用するフォルダ生成
    for file in ${DOT_FILES[@]}
    do
        echo "...create folder: ~/$file"
        mkdir -p $HOME/$file
    done

    # ~/.vim/のdict, colorsを生成
    if [ -a $HOME/.vim/dict ]; then
        echo "...remove folder : $HOME/.vim/dict"
        rm $HOME/.vim/dict
    fi
    if [ -a $HOME/.vim/colors ]; then
        echo "...remove folder : $HOME/.vim/colors"
        rm $HOME/.vim/colors
    fi

    ln -s $HOME/.bundle/alpaca/dict $HOME/.vim/dict
    echo "done!!: $HOME/.bunlde/alpaca/dict   => $HOME/.vim/dict"
    ln -s $HOME/.bundle/alpaca/colors $HOME/.vim/colors
    echo "done!!: $HOME/.bunlde/alpaca/colors => $HOME/.vim/colors"
fi

# finderで隠しファイルを表示する
echo "\n"
read -p "Do you wish to show hidden files on finder? y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    defaults write com.apple.finder AppleShowAllFiles TRUE
    echo "done!! change setting about finder"
    echo "...restart finder\n"
    killall Finder
fi

# 秘密鍵を生成して、githubから残りのファイルをDLする
read -p "Do you wish to install .ssh and .memolist settings from github? " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    echo "...create .ssh directory"
    rm -rf ~/.ssh
    mkdir -p ~/.ssh
    cp `pwd`/config $HOME/.ssh/
    echo "decode identify file. please input password!"
    echo "\n"
    echo "hint:i love alpaca ・T・"
    openssl enc -d -aes256 -in github -out ~/.ssh/github
    chmod 700 $HOME/.ssh
    chmod 600 $HOME/.ssh/github
    echo "\n"
    echo "...clone from github\n"
    git clone github:taichouchou2/serclet.git `pwd`/serclet
    chmod +x `pwd`/serclet/setup.sh
    echo "...run serclet setup.sh \n"
    `pwd`/serclet/setup.sh
fi

# 最後にコメント
echo "\n"
echo "***************finish********************"
echo "    以下を実行して、インストールは完了します   "
echo "  1.vimを起動して:NeoBundleInstallを実行"
echo "  2.rvmをインストールします。http://unfiniti.com/software/mac/jewelrybox"
echo "     ruby1.9.3-p194をインストールします"
echo "  3.brewとgemをインストールします"
echo "     /usr/bin/ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
echo "     list/brew.txtのbinをインストールしてください"
echo "\n"
echo "                  let's enjoy! vim-life $USER"

