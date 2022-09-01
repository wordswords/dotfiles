#!/usr/bin/env zsh
# vim: spell set nowrap

## To be run after installation of oh-my-zsh
set -e

# Load in status message printing functions
source ./deploy-common.sh
# Load in functions
source ./.zshenv

report_heading 'Deploy Dotfiles: Part 2'

report_progress 'Running ctags'
ctags -R *
report_done

report_progress 'Installing curl'
sudo apt install curl -y
report_done

report_progress 'Setting up pbcopy and pbpaste aliases'
sudo apt install xclip xsel
report_done

report_progress 'Installing latest nodejs and bash-language-server'

# Install latest nodejs
curl -sfLS install-node.vercel.app/lts > node-lts.sh
chmod u+x node-lts.sh
sudo ./node-lts.sh --yes
rm ./node-lts.sh
export PATH="/usr/local/bin/:$PATH"
report_done

report_progress 'Install LanguageTool grammar checker'
cd ~/.dotfiles
ls ./LanguageTool-5.2.zip || $( wget https://languagetool.org/download/LanguageTool-5.2.zip && unzip LanguageTool-5.2.zip ) 
cd -
report_done

report_progress 'Removing existing dotfiles'
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bash_profile
report_done

report_progress 'Installing oh-my-zsh plugins'
cd ~/.oh-my-zsh/plugins && ( git clone https://github.com/zsh-users/zsh-syntax-highlighting.git && \
git clone https://github.com/zsh-users/zsh-autosuggestions.git && \
git clone https://github.com/agkozak/zsh-z.git ./zsh-z && \
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && yes | ~/.fzf/install ) || echo "INFO: OMZ plugins already seem to be installed."
report_done

report_progress 'Removing default ~/.zshrc directory'
rm -rf ~/.zshrc #remove the default .zshrc generated by the oh-my-zsh install
report_done

report_progress 'Setting up local bin directory'
mkdir -p ~/bin
cp -furs ~/.dotfiles/bin/* ~/bin/
report_done

report_progress 'Setting up symbolic links'
ln --force -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln --force -s ~/.dotfiles/.bash_aliases ~/.zsh_aliases
ln --force -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln --force -s ~/.dotfiles/.bash_profile_remote ~/.bash_profile_remote
ln --force -s -n ~/.dotfiles/.vim ~/.vim
ln --force -s ~/.dotfiles/.vimrc ~/.vimrc
ln --force -s ~/.dotfiles/.zshrc ~/.zshrc
ln --force -s ~/.dotfiles/.zshenv ~/.zshenv
ln --force -s ~/.dotfiles/coc-settings.json ~/.vim/coc-settings.json
report_done

report_progress 'Creating vim backup file directory structure'
mkdir -p ~/.backup/vim/swap || echo "INFO: Swapfile backup directory seems to be already there."
mkdir ~/.backup/vim/undos || echo "INFO: Undofile backup directory seems to be already there."
report_done

report_progress 'Testing Github access'
ssh -T git@github.com 2> /tmp/githubaccesscheck.txt || echo ""
grep 'successfully authenticated' /tmp/githubaccesscheck.txt || ( echo ERROR: Github acccess not available && exit 1; )
rm /tmp/githubaccesscheck.txt
report_done

report_progress 'Installing/updating vim plugins to latest version'
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
report_done

report_progress 'Patching NerdTree to remove deprecated error'
cp ~/.dotfiles/nerdtree_plugin_fix.diff ~/.vim/pack/plugins/start/nerdtree-git-plugin/nerdtree_plugin
cd ~/.vim/pack/plugins/start/nerdtree-git-plugin/nerdtree_plugin
git apply nerdtree_plugin_fix.diff
cd -
report_done

report_progress 'Installing vim8/coc'
mkdir -p ~/.vim/pack/coc/start
cd ~/.vim/pack/coc/start
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -
report_done

report_progress 'Installing vim8/coc extensions'
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
echo '{"dependencies":{}}'> package.json

# Change extension names to the extensions you need
npm install coc-sh coc-tsserver coc-vimlsp coc-json coc-prettier coc-html coc-css coc-python --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
sudo npm install -g vim-language-server
vim -c 'CocInstall coc-vimlsp|q'
vim -c 'CocUpdateSync|q'
report_done

report_progress 'Installing vim colorscheme'
git clone https://github.com/shannonmoeller/vim-monokai256 ./colorscheme
mv ./colorscheme/colors/* ~/.vim/colors/
rm -rf ./colorscheme
report_done

report_progress 'Installing pynvim for python integration with vim'
pip3 install --user pynvim
pip3 install jedi
report_done

report_progress 'Setting default git config.. change this if you are not David Craddock!'
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
report_done

report_progress 'Installing and configuring Joplin CLI notetaking app'
( which joplin-cli 2>/dev/null && sudo npm update -g joplin ) || ( NPM_CONFIG_PREFIX=~/.joplin-bin npm install -g joplin && sudo ln -s ~/.joplin-bin/bin/joplin /usr/bin/joplin-cli ) 
report_done

report_progress 'Import Joplin config'
( ls ~/.config | grep -q joplin >/dev/null || /usr/bin/joplin-cli config --import < ~/.dotfiles/joplin.config )
report_done

report_progress 'Creating SECURE_DIR if it doesnt already exist'
ls $SECURE_DIR || ( mkdir -p $SECURE_DIR )
report_done

report_progress 'Encrypting Joplin notes'
unlock && mkdir -p $SECURE_DIR/.config || echo '' && ( mv ~/.config/joplin
$SECURE_DIR/.config/ 2>/dev/null || echo '' ) && ( ln -sf $SECURE_DIR/.config/joplin ~/.config/joplin )
report_done

report_progress 'Syncing Joplin notes, you will now be asked to log into dropbox'
syncnotes

report_progress 'Changing shell to /bin/zsh.'
sudo chsh -s $(which zsh 2>/dev/null) $(whoami)
report_done

report_progress 'Customising Fortune random quoter'
set -o extendedglob
( sudo rm -rf "/usr/share/games/fortunes/riddles*" 2>/dev/null || echo '' )
( sudo rm -rf "/usr/share/games/fortunes/fortune*" 2>/dev/null || echo '' )
( sudo rm -rf "/usr/share/games/fortunes/literature*" 2>/dev/null || echo '' )
set +o extendedglob
report_done
echo
echo "-- OPTIONAL EXTRAS -- "
echo
read "?Do you want to install JIRA-CLI Go client? (y/N)? " JIRAINSTALL
if [[ ${JIRAINSTALL} == 'yes' || ${JIRAINSTALL} == 'y' || ${JIRAINSTALL} == 'Y' ]];
then
    sudo snap install go --classic 2>/dev/null || sudo snap refresh go
    go install golang.org/dl/go1.19@latest
    go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest
    report_progress '''JIRA-CLI go client installed. You will now have to setup
    it with your local JIRA_API token, see: https://github.com/ankitpokhrel/jira-cli/'''
    report_done
fi
echo
read "?Do you want to install or update the Ubuntu snap images of Spotify and Morgen? (y/N)? " SNAPINSTALL
if [[ ${SNAPINSTALL} == 'yes' || ${SNAPINSTALL} == 'y' || ${SNAPINSTALL} == 'Y' ]];
then
    report_progress 'Installing Morgen calendar app via snap'
    sudo snap install morgen 2>/dev/null || sudo snap refresh morgen
    report_done

    report_progress 'Installing Spotify app via snap'
    sudo snap install spotify 2>/dev/null || sudo snap refresh spotify
    report_done
fi
echo
echo "-- NEXT STEPS -- "
echo
echo '''You will have to install your nerdfont manually, download
DroidSansNerdFontMono from https://github.com/ryanoasis/nerd-fonts . After this,
you will have to set your terminal emulator to use said font.'''

report_progress 'Deployment process finished'
report_done

