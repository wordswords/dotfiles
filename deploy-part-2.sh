#!/usr/bin/env bash
## To be run after installation of oh-my-zsh

# Load in status message printing functions
source ./deploy-common.sh

baseos=$(get_os)

report_progress 1 'Installing curl and the latest version of node for vim/coc'

if [ "$baseos" = "osx" ]; then
  brew install curl
else
  sudo apt-get install curl -y
fi


curl -sL install-node.now.sh/lts | sudo bash

report_progress 1 'Deploying .dotfiles: Part 2'

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

git clone git@github.com:LucHermitte/alternate-lite.git
git clone git@github.com:LucHermitte/lh-brackets.git
git clone git@github.com:LucHermitte/lh-cpp.git
git clone git@github.com:LucHermitte/lh-dev.git
git clone git@github.com:LucHermitte/lh-style.git
git clone git@github.com:LucHermitte/lh-tags.git
git clone git@github.com:LucHermitte/lh-vim-lib.git
git clone git@github.com:LucHermitte/mu-template.git
git clone git@github.com:LucHermitte/searchInRuntime.git
git clone git@github.com:Shougo/denite.nvim.git
git clone git@github.com:Xuyuanp/nerdtree-git-plugin.git
git clone git@github.com:ciaranm/securemodelines.git ./securemodelines
git clone git@github.com:dpelle/vim-LanguageTool
git clone git@github.com:godlygeek/tabular.git
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
git clone git@github.com:rhysd/vim-grammarous
git clone git@github.com:roxma/nvim-yarp.git
git clone git@github.com:roxma/vim-hug-neovim-rpc
git clone git@github.com:ryanoasis/vim-devicons.git
git clone git@github.com:scrooloose/nerdtree.git
git clone git@github.com:tomasr/molokai.git
git clone git@github.com:tomtom/stakeholders_vim.git
git clone git@github.com:tpope/vim-bundler.git
git clone git@github.com:tpope/vim-commentary
git clone git@github.com:tpope/vim-fugitive.git
git clone git@github.com:tpope/vim-git
git clone git@github.com:tpope/vim-rails.git
git clone git@github.com:vim-airline/vim-airline
git clone git@github.com:vimwiki/vimwiki.git
git clone git@github.com:z0mbix/vim-shfmt.git
git clone https://github.com/prettier/vim-prettier
git clone --recursive git@github.com:davidhalter/jedi-vim.git
mv ./securemodelines/plugin/* ~/.vim/plugin/
rm -rf ./securemodelines

report_progress 2 'Patching NerdTree to remove deprecated error..'
cp ~/.dotfiles/nerdtree_plugin_fix.diff ~/.vim/bundle/nerdtree-git-plugin/nerdtree_plugin
cd ~/.vim/bundle/nerdtree-git-plugin/nerdtree_plugin
git apply nerdtree_plugin_fix.diff
cd -

report_progress 2 'Installing vim8/coc'
mkdir -p ~/.vim/pack/coc/start\ncd ~/.vim/pack/coc/start
cd ~/.vim/pack/coc/start
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz > release.tgz && tar xzfv release.tgz
cd -
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
npm install coc-snippets coc-tsserver coc-json coc-html coc-css coc-python --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

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
