#!/usr/bin/env bash
## To be run after installation of oh-my-zsh

# Load in status message printing functions
source ./deploy-common.sh

baseos=$(get_os)

report_progress 1 'Deploying .dotfiles: Part 2'

report_progress 1 'Installing curl'

if [ "$baseos" = "osx" ]; then
  brew install curl
else
  sudo apt-get install curl -y
fi

report_progress 1 'Installing latest nodejs and bash-language-server'

# Install latest nodejs
curl -s https://install-node.now.sh | sh -s --
export PATH="/usr/local/bin/:$PATH"
# Or use package manager, e.g.
# sudo apt-get install nodejs

# Install bash language server for coc
sudo npm i -g bash-language-server

report_progress 2 'Removing existing dotfiles..'
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bash_profile

report_progress 2 'Installing oh-my-zsh plugins..'
cd ~/.oh-my-zsh/plugins || exit 1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/agkozak/zsh-z.git ./zsh-z
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && yes | ~/.fzf/install

report_progress 2 'Removing default ~/.zshrc directory..'
rm -rf ~/.zshrc #remove the default .zshrc generated by the oh-my-zsh install

report_progress 2 'Setting up local bin directory..'
mkdir -p ~/bin

if [ "$baseos" = "osx" ]; then
  gcp -urs ~/.dotfiles/bin/* ~/bin/
else
  cp -urs ~/.dotfiles/bin/* ~/bin/
fi

report_progress 2 'Setting up symbolic links..'
ln -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln -s ~/.dotfiles/.bash_aliases ~/.zsh_aliases
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.bash_profile_remote ~/.bash_profile_remote
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc

report_progress 2 'Installing vim plugins latest version..'
rm -rf ~/.dotfiles/.vim/bundle/*
cd ~/.dotfiles/.vim/bundle/ || exit 1

git clone git@github.com:Shougo/denite.nvim.git
git clone git@github.com:Xuyuanp/nerdtree-git-plugin.git
git clone git@github.com:ciaranm/securemodelines.git ./securemodelines
git clone git@github.com:dpelle/vim-LanguageTool
git clone git@github.com:jelera/vim-javascript-syntax.git
git clone git@github.com:junegunn/goyo.vim
git clone git@github.com:junegunn/limelight.vim
git clone git@github.com:kana/vim-textobj-user
git clone git@github.com:reedes/vim-lexical
git clone git@github.com:reedes/vim-litecorrect
git clone git@github.com:reedes/vim-pencil
git clone git@github.com:reedes/vim-textobj-quote
git clone git@github.com:reedes/vim-textobj-sentence
git clone git@github.com:reedes/vim-wordy.git
git clone git@github.com:roxma/nvim-yarp.git
git clone git@github.com:roxma/vim-hug-neovim-rpc
git clone git@github.com:ryanoasis/vim-devicons.git
git clone git@github.com:scrooloose/nerdtree.git
git clone git@github.com:tomasr/molokai.git
git clone git@github.com:tpope/vim-bundler.git
git clone git@github.com:tpope/vim-fugitive.git
git clone git@github.com:tpope/vim-git
git clone git@github.com:vim-airline/vim-airline
mv ./securemodelines/plugin/* ~/.vim/plugin/
rm -rf ./securemodelines

report_progress 2 'Patching NerdTree to remove deprecated error..'
cp ~/.dotfiles/nerdtree_plugin_fix.diff ~/.vim/bundle/nerdtree-git-plugin/nerdtree_plugin
cd ~/.vim/bundle/nerdtree-git-plugin/nerdtree_plugin
git apply nerdtree_plugin_fix.diff
cd -

report_progress 2 'Installing vim8/coc'

# Use package feature to install coc.nvim

# for vim8
mkdir -p ~/.vim/pack/coc/start
cd ~/.vim/pack/coc/start
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -

# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi

report_progress 2 'Installing yarn'

curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
export PATH=$PATH:~/.yarn/bin
yarn config set "strict-ssl" false -g

report_progress 2 'Installing vim8/coc extensions'
# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
# Change extension names to the extensions you need
npm install coc-snippets coc-tsserver coc-json coc-html coc-css coc-python coc-sh --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

# Install coc-settings file
cp ~/.dotfiles/coc-settings.json ~/.vim/coc-settings.json

report_progress 2 'Installing vim colorscheme..'
git clone https://github.com/shannonmoeller/vim-monokai256 ./colorscheme
mv ./colorscheme/colors/* ~/.vim/colors/
rm -rf ./colorscheme

report_progress 2 'Installing oh-my-zsh plugins..'
cd ~/.oh-my-zsh/plugins || exit 1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

report_progress 2 'Installing pynvim for python integration with vim..'
pip3 install --user pynvim

report_progress 2 'Setting default git config.. change this if you are not David Craddock!'
# Git configuration for the default user, will still have to specify
# email address
git config --global core.editor vim
git config --global user.name "David Craddock"

report_progress 1 'Deploy script finished.'
if [ "$baseos" = "osx" ]; then
  echo "NEXT STEPS: If using iterm2, set your font in iterm2 settings to a Powerline font both for ASCII and non-ASCII font types!"
  echo "After this, run deploy-iterm2-default-profile.sh"
else
  echo "NEXT STEPS: Linux detected. You will have to install your nerdfont manually, download DroidSansNerdFontMono from https://github.com/ryanoasis/nerd-fonts"
  echo "After this, you will have to set your terminal emulator to use said font."
fi
