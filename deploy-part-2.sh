#!/usr/bin/env bash
## To be run after installation of oh-my-zsh

set -e

# Load in status message printing functions
source ./deploy-common.sh

if [ "$baseos" = "linux" ]; then
    sudo apt update
fi

baseos=$(get_os)

report_progress 1 'Deploying .dotfiles: Part 2'

report_progress 2 'Installing ctags'

#sudo apt install ctags -y
ctags -R *

report_progress 2 'Installing curl'

sudo apt install curl -y
report_progress 2 'Setting up pbcopy and pbpaste aliases'
sudo apt install xclip xsel

report_progress 2 'Installing latest nodejs and bash-language-server'

# Install latest nodejs
curl -sfLS install-node.vercel.app/lts > node-lts.sh
chmod u+x node-lts.sh
sudo ./node-lts.sh --yes
rm ./node-lts.sh
export PATH="/usr/local/bin/:$PATH"

report_progress 2 'Install LanguageTool grammar checker'
cd ~/.dotfiles
ls ./LanguageTool-5.2.zip || $( wget https://languagetool.org/download/LanguageTool-5.2.zip && unzip LanguageTool-5.2.zip ) 
cd -

report_progress 2 'Removing existing dotfiles..'
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bash_profile

report_progress 2 'Installing oh-my-zsh plugins..'
cd ~/.oh-my-zsh/plugins && ( git clone https://github.com/zsh-users/zsh-syntax-highlighting.git && \
git clone https://github.com/zsh-users/zsh-autosuggestions.git && \
git clone https://github.com/agkozak/zsh-z.git ./zsh-z && \
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && yes | ~/.fzf/install ) || echo "INFO: OMZ plugins already seem to be installed."

report_progress 2 'Removing default ~/.zshrc directory..'
rm -rf ~/.zshrc #remove the default .zshrc generated by the oh-my-zsh install

report_progress 2 'Setting up local bin directory..'
mkdir -p ~/bin
cp -furs ~/.dotfiles/bin/* ~/bin/

report_progress 2 'Setting up symbolic links..'
ln --force -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln --force -s ~/.dotfiles/.bash_aliases ~/.zsh_aliases
ln --force -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln --force -s ~/.dotfiles/.bash_profile_remote ~/.bash_profile_remote
ln --force -s -n ~/.dotfiles/.vim ~/.vim
ln --force -s ~/.dotfiles/.vimrc ~/.vimrc
ln --force -s ~/.dotfiles/.zshrc ~/.zshrc
ln --force -s ~/.dotfiles/coc-settings.json ~/.vim/coc-settings.json

report_progress 2 'Creating vim backup file directory structure..'
mkdir -p ~/.backup/vim/swap || echo "INFO: Swapfile backup directory seems to be already there."
mkdir ~/.backup/vim/undos || echo "INFO: Undofile backup directory seems to be already there."

report_progress 2 'Testing Github access..'
ssh -T git@github.com 2> /tmp/githubaccesscheck.txt || echo ""
grep 'successfully authenticated' /tmp/githubaccesscheck.txt || ( echo ERROR: Github acccess not available && exit 1; )
rm /tmp/githubaccesscheck.txt

report_progress 2 'Installing/updating vim plugins to latest version..'
rm -rf ~/.dotfiles/.vim/pack/plugins/start/*
mkdir -p ~/.dotfiles/.vim/pack/plugins/start/
cd ~/.dotfiles/.vim/pack/plugins/start/ || exit 1

set -x
git submodule init
set +x

set +e # turn exit on error return off
git submodule add git@github.com:Shougo/denite.nvim.git
git submodule add git@github.com:Xuyuanp/nerdtree-git-plugin.git
git submodule add git@github.com:ciaranm/securemodelines.git
git submodule add git@github.com:dpelle/vim-LanguageTool
git submodule add git@github.com:jelera/vim-javascript-syntax.git
git submodule add git@github.com:junegunn/goyo.vim
git submodule add git@github.com:junegunn/limelight.vim
git submodule add git@github.com:kana/vim-textobj-user
git submodule add git@github.com:reedes/vim-lexical
git submodule add git@github.com:reedes/vim-litecorrect
git submodule add git@github.com:reedes/vim-pencil
git submodule add git@github.com:reedes/vim-textobj-quote
git submodule add git@github.com:reedes/vim-textobj-sentence
git submodule add git@github.com:reedes/vim-wordy.git
git submodule add git@github.com:roxma/nvim-yarp.git
git submodule add git@github.com:roxma/vim-hug-neovim-rpc
git submodule add git@github.com:ryanoasis/vim-devicons.git
git submodule add git@github.com:scrooloose/nerdtree.git
git submodule add git@github.com:tomasr/molokai.git
git submodule add git@github.com:tpope/vim-bundler.git
git submodule add git@github.com:tpope/vim-fugitive.git
git submodule add git@github.com:tpope/vim-git
git submodule add git@github.com:vim-airline/vim-airline
set -e # turn exit on error return back on

set -x
git submodule update --recursive --remote --merge
set +x

report_progress 2 'Install securemodelines security patch for vim..'
mv ./securemodelines/plugin/* ~/.vim/plugin/
rm -rf ./securemodelines

report_progress 2 'Patching NerdTree to remove deprecated error..'
cp ~/.dotfiles/nerdtree_plugin_fix.diff ~/.vim/pack/plugins/start/nerdtree-git-plugin/nerdtree_plugin
cd ~/.vim/pack/plugins/start/nerdtree-git-plugin/nerdtree_plugin
git apply nerdtree_plugin_fix.diff
cd -

report_progress 2 'Installing vim8/coc'
mkdir -p ~/.vim/pack/coc/start
cd ~/.vim/pack/coc/start
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -

report_progress 2 'Installing yarn'
curl --compressed -o- -L https://yarnpkg.com/install.sh | bash
export PATH=$PATH:~/.yarn/bin
yarn config set "strict-ssl" false -g

report_progress 2 'Installing vim8/coc extensions'
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
# Change extension names to the extensions you need
npm install coc-snippets coc-sh coc-tsserver coc-json coc-html coc-css coc-python --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

report_progress 2 'Installing vim colorscheme..'
git clone https://github.com/shannonmoeller/vim-monokai256 ./colorscheme
mv ./colorscheme/colors/* ~/.vim/colors/
rm -rf ./colorscheme

report_progress 2 'Installing pynvim for python integration with vim..'
pip3 install --user pynvim
pip3 install jedi

report_progress 2 'Setting default git config.. change this if you are not David Craddock!'
rm ~/.gitconfig
set -x
git config --global alias.logline "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global commit.template ~/.dotfiles/.git-commit-template
git config --global core.editor vim
git config --global diff.tool vimdiff
git config --global merge.conflictstyle diff3
git config --global merge.tool fugitive
git config --global mergetool.fugitive.cmd 'vim -f -c "Gvdiffsplit!" "$MERGED"'
git config --global mergetool.keepBackup false
git config --global mergetool.prompt false
git config --global user.email "$( cat ~/.dotfiles/secretseadd | tr 'N-ZA-Mn-za-m' 'A-Za-z' )"
git config --global user.name "David Craddock"
set +x

report_progress 2 'Installing and configuring Joplin CLI notetaking app'
( which joplin && sudo npm update -g joplin ) || ( NPM_CONFIG_PREFIX=~/.joplin-bin npm install -g joplin && sudo ln -s ~/.joplin-bin/bin/joplin /usr/bin/joplin && /usr/bin/joplin config --import < ~/.dotfiles/joplin.config )

report_progress 2 'Syncing Joplin notes, you will now be asked to log into dropbox'
/usr/bin/joplin sync

read SNAPINSTALL
if [[ ${SNAPINSTALL} == 'yes' || ${SNAPINSTALL} == 'y' || ${SNAPINSTALL} == 'Y' ]];
then
    report_progress 2 'Installing Joplin UI app via snap'
    sudo snap install joplin 2>/dev/null || sudo snap refresh joplin

    report_progress 2 'Installing Morgen calendar app via snap'
    sudo snap install morgen 2>/dev/null || sudo snap refresh morgen

    report_progress 2 'Installing Spotify app via snap'
    sudo snap install spotify 2>/dev/null || sudo snap refresh spotify
fi

report_progress 2 'Changing shell to /bin/zsh.'
sudo chsh -s $(which zsh) $(whoami)

report_progress 1 'Deploy script finished.'
echo "NEXT STEPS: You will have to install your nerdfont manually, download DroidSansNerdFontMono from https://github.com/ryanoasis/nerd-fonts"
echo "After this, you will have to set your terminal emulator to use said font."

