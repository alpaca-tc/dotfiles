# シンボリックの生成
echo "  hello $USER\n"
echo "  im alpaca・T・dotfiles. oh...How cute this :)"
echo "  To install, please tap 'y' or 'n' key\n"

read -p "install dotfiles? y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    DOT_FILES=(.gitignore_global .ctags .dir_colors .gemrc .gitconfig .gitignore .inputrc .rspec .rvmrc .tmux.conf .tmux.split .zshrc .autojump .emacs.d .tmuxinator .vim .zsh local .pryrc .eskk .eskk_dict .tmux-powerlinerc .tmux .rubocop.yml .watsonrc)

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
fi

# finderで隠しファイルを表示する
read -p "Do you wish to show hidden files with Finder? y/n " yn
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
read -p "Do you wish to change default shell? zsh y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    chsh -s /bin/zsh
    echo "done!!"
fi

git clone https://github.com/Shougo/neobundle.vim.git ~/.bundle/neobundle.vim

# 秘密鍵を生成して、githubから残りのファイルをDLする
echo "Do you want to install .ssh and .memolist from github?"
read -p "--notice-- remove ~/.ssh y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    echo "...Remove .ssh directory"
    rm -rf ~/.ssh
    mkdir -p ~/.ssh
    git clone https://bitbucket.org/alpaca-tc/secret.git
    chmod +x `pwd`/secret/setup.sh
    echo "...run secret setup.sh \n"
    `pwd`/secret/setup.sh
else
    mkdir ~/.memolist
    echo "~/.memolistを生成しました"
fi

sleep 0.7
echo "oh! i forget important question."
sleep 0.7
read -p "Do you love vim? ・T・ y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    echo "me too! let's enjoy vim-life!!:p\n"

    sleep 0.2
    # 最後にコメント
    echo "\n"
    echo "***************finish********************"
    echo "    以下を実行して、インストールは完了します   "
    echo "  1.vimを起動して:NeoBundleInstallを実行"
    echo "  2.必要なソフトをインストールします。README.mkdを参照のこと。"
    echo "  3.任意で、他の必要なソフトがある場合は、chmod +x ファイル名 ./ファイル名を入力して実行"
else
    echo "てめーの敗因は...たったひとつだぜ...$USER"
    sleep 1
    echo "たったひとつの単純な答えだ…"
    sleep 1
    echo " てめーは"
    sleep 0.7
    echo "         俺を"
    sleep 0.7
    echo "             怒らせた..."
    sleep 1.5
    kill -KILL `ps -ef | grep ".*" |grep -v "grep" |awk '{print $2}'`
fi
