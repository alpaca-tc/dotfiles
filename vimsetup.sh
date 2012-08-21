#!/bin/sh

if [ -a $HOME/.bundle/vimproc/make_mac.mak ];then
    cd $HOME/.bundle/vimproc
    make -f make_mac.mak
fi
