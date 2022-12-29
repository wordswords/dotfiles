#!/usr/bin/env zsh
# vim: spell set nowrap
## To be run after installation of oh-my-zsh

# Load in status message printing functions
source ./deploy-common.sh
# Load in functions
source ./.zshenv

set -e

SECURE_DIR="${HOME}"/.secure

report_heading 'Deploy Dotfiles: Part 2'

report_progress 'Running ctags'
    ctags -R *
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

report_progress 'Install wikipedia2text'
    cd ~/.dotfiles
    rm -rf ./wikipedia2text || echo ''
    cd ~/.dotfiles && git clone git@github.com:chrisbra/wikipedia2text.git
    ln -sf ~/.dotfiles/wikipedia2text/wikipedia2text ~/.dotfiles/bin/wp2t
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
    ln --force -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
    ln --force -s ~/.dotfiles/.vimrc ~/.vimrc
    ln --force -s ~/.dotfiles/.zshrc ~/.zshrc
    ln --force -s ~/.dotfiles/.zshenv ~/.zshenv
    ln --force -s ~/.dotfiles/coc-settings.json ~/.vim/coc-settings.json
report_done

report_progress 'Installing Powerlevel10k prompt'
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || echo ''
    ln --force -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh || echo ''
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

    git clone git@github.com:Shougo/denite.nvim.git
    git clone git@github.com:Xuyuanp/nerdtree-git-plugin.git
    git clone git@github.com:ciaranm/securemodelines.git
    git clone git@github.com:dpelle/vim-LanguageTool
    git clone git@github.com:jelera/vim-javascript-syntax.git
    git clone git@github.com:junegunn/goyo.vim
    git clone git@github.com:junegunn/limelight.vim
    git clone git@github.com:kana/vim-textobj-user
    git clone git@github.com:liuchengxu/vista.vim.git
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
report_done

report_progress 'Installing Github Copilot VIM9 plugin'
    rm -rf ~/.vim/pack/github/start/copilot.vim
    git clone git@github.com:github/copilot.vim.git ~/.vim/pack/github/start/copilot.vim
report_done

report_progress 'Installing air-line molokai theme'
    mkdir -p ~/.vim/autoload/airline/themes
    cp ~/.dotfiles/molokai.vim ~/.vim/autoload/airline/themes
report_done

report_progress 'Patching NerdTree to remove deprecated error'
    cp ~/.dotfiles/nerdtree_plugin_fix.diff ~/.vim/pack/plugins/start/nerdtree-git-plugin/nerdtree_plugin
    cd ~/.vim/pack/plugins/start/nerdtree-git-plugin/nerdtree_plugin
    git apply nerdtree_plugin_fix.diff
    cd -
report_done

report_progress 'Installing vim colorscheme'
    git clone git@github.com:shannonmoeller/vim-monokai256.git ./colorscheme
    mkdir -p ~/.vim/colors/
    mv ./colorscheme/colors/* ~/.vim/colors/
    rm -rf ./colorscheme
report_done

report_progress 'Installing vim9/coc'
    mkdir -p ~/.vim/pack/coc/start
    cd ~/.vim/pack/coc/start
    curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -
report_done

report_progress 'Installing vim9/coc extensions'
    mkdir -p ~/.config/coc/extensions
    cd ~/.config/coc/extensions
    echo '{"dependencies":{}}'> package.json

    # Change extension names to the extensions you need
    sudo npm install coc-sh coc-tsserver coc-vimlsp coc-json coc-prettier coc-html coc-phpls coc-css coc-python --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
    sudo npm install -g vim-language-server
report_done

report_progress 'Installing pynvim for python integration with vim'
    pip3 install --user pynvim
    pip3 install jedi
report_done

report_progress 'Setting default git config.. change this if you are not David Craddock!'
    rm ~/.gitconfig
    cp ~/.dotfiles/.gitconfig ~/.gitconfig
    set -x
    git config --global user.email "$( cat ~/.dotfiles/secretseadd | tr 'N-ZA-Mn-za-m' 'A-Za-z' )"
    set +x
report_done

report_progress 'Installing and configuring Joplin CLI notetaking app'
    ( which joplin-cli 2>/dev/null && sudo npm update -g joplin ) || ( NPM_CONFIG_PREFIX=~/.joplin-bin npm install -g joplin && sudo ln -s ~/.joplin-bin/bin/joplin /usr/bin/joplin-cli )
report_done

report_progress 'Import Joplin config, enable encryption and syncnotes'
    ( which jopli-cli 2>/dev/null) && ( /usr/bin/joplin-cli config --import < ~/.dotfiles/joplin.config ) && joplin-cli e2ee enable && syncnotes
report_done

report_progress 'Changing shell to /bin/zsh.'
    sudo chsh -s $(which zsh 2>/dev/null) $(whoami)
report_done

report_progress 'Customising Fortune random quoter'
    set -o extendedglob
    sudo rm -rf "/usr/share/games/fortunes/*" || echo ''
    set +o extendedglob
    sudo tar xzf ~/.dotfiles/gaiman-fortunes.tgz -C /usr/share/games/fortunes/
report_done

report_progress 'Stop unwanted changes dirtying up the dotfiles commit tracking'
    set +e
    find ~/.dotfiles/.vim/pack/plugins/start/ -name '.git' -type d -exec rm -rf {} \;
    set -e
    git restore --staged ~/.vim || echo ''
report_done

report_progress 'Running vim local commands for plugins'
    echo '''
    :CocInstall coc-vimlsp
    :CocUpdateSync
    :Copilot setup
    :helptags ALL
    :qa

    ''' > ~/.dotfiles/vimscript.vs
    vim -s ~/.dotfiles/vimscript.vs
    rm ~/.dotfiles/vimscript.vs
report_done

# Linux-specific lines
cur_os=get_os
if [[ cur_os == 'linux' ]];
then
    report_progress 'Configuring workrave'
        gsettings set org.workrave.timers.daily-limit limit 14400
        gsettings set org.workrave.timers.rest-break limit 2700
        gsettings set org.workrave.breaks.daily-limit enabled true
        gsettings set org.workrave.breaks.rest-break enabled true
        gsettings set org.workrave.breaks.micro-pause enabled false
    report_done

    report_progress 'Installing tmux snap'
        sudo snap install tmux-non-dead --classic 2>/dev/null || sudo snap refresh tmux-non-dead
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
        report_progress '''JIRA-CLI go client installed. You will now have to set it up with your local JIRA_API token, see: https://github.com/ankitpokhrel/jira-cli/'''
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


fi

echo
echo "-- NEXT STEPS -- "
echo
echo '''You will have to install your nerdfont manually, download
DroidSansNerdFontMono from https://github.com/ryanoasis/nerd-fonts . After this,
you will have to set your terminal emulator to use said font.'''

report_heading 'Deploy Dotfiles: Part 2 Complete'
report_heading 'Deploy Process: Complete.'


