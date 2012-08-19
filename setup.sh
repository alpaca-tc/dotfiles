# シンボリックの生成
echo "  hello :)"
echo "  this is alpaca・T・dotfiles. oh...cute!!!\n"
echo "  To install, please tap 'y' or 'n' key\n"

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
    VIM_FOLDERS=( dict colors )
    for file in ${VIM_FOLDERS[@]}
    do
        if [ -a $HOME/.vim/$file ]; then
            if [ "$yn" != "a" ]; then
                echo "exists: ~/.vim/$file"
                read -p "override? y/n/a " yn
            fi
        else
            if [ $yn != "a" ]; then
                export yn=y
            fi
        fi

        if [ $yn = "y" -o $yn = "Y" -o $yn = "a" ]; then
            rm -rf $HOME/.vim/$file
            ln -s $HOME/.bundle/alpaca/$file $HOME/.vim/$file
            echo "done!!: symbolic link  $HOME/.bunlde/alpaca/$file   => $HOME/.vim/$file"
        fi
    done
fi

# finderで隠しファイルを表示する
read -p "Do you wish to show hidden files on finder? y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    defaults write com.apple.finder AppleShowAllFiles TRUE
    echo "done!! change setting about finder"
    echo "...restart finder\n"
    killall Finder
fi

# 秘密鍵を生成して、githubから残りのファイルをDLする
echo "Do you wish to install .ssh and .memolist settings from github? "
read -p "--notice-- remove ~/.ssh y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    echo "...re create .ssh directory"
    rm -rf ~/.ssh
    mkdir -p ~/.ssh
    cp `pwd`/config $HOME/.ssh/
    echo "decode identify file. please input password!\n"
    echo "hint: i love alpaca! ・T・"
    openssl enc -d -aes256 -in github -out ~/.ssh/github
    if [ -a $HOME/.ssh/github ]; then
        chmod 700 $HOME/.ssh
        chmod 600 $HOME/.ssh/github
        echo "\n...clone from github\n"
        git clone github:taichouchou2/serclet.git `pwd`/serclet
        chmod +x `pwd`/serclet/setup.sh
        echo "...run serclet setup.sh \n"
        `pwd`/serclet/setup.sh
    else
        echo "failed decode :p"
    fi
fi

sleep 0.2
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
echo "                  let's enjoy! $USER"

read -p "Do you love vim?  y/n " yn
if [ $yn = "y" -o $yn = "Y" ]; then
    echo "OK! me too. let's enjoy vim-life!!:)"
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

