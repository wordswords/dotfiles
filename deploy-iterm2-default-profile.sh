#!/bin/bash -xe
cd iterm2
sed -i -e "s/davcra01/${USER}/g" com.googlecode.iterm2.plist
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "/Users/${USER}/.dotfiles/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
open /Applications/iTerm.app

