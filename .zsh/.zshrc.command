rm -f $DOTFILES_DIR/list/*
mkdir -p $DOTFILES_DIR/list

date > $DOTFILES_DIR/list/brewlist.txt
date > $DOTFILES_DIR/list/gemlist.txt
brew list >> $DOTFILES_DIR/list/brewlist.txt
gem list >> $DOTFILES_DIR/list/gemlist.txt
