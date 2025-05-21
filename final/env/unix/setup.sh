#!/bin/sh

git rev-parse --show-toplevel &&
ln -s `git rev-parse --show-toplevel` ~/.vim
