#!/bin/bash

NPM_CONFIG_PREFIX=~/.joplin-bin npm install -g joplin
ln -sf ~/.joplin-bin/bin/joplin ~/bin/joplin-cli

