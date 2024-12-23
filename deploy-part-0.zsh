#!/bin/zsh
# vim: foldmethod=marker foldmarker=report_progress,report_done

set -e
source ./deploy-common.sh
cur_os=$(get_os)
report_heading 'Deploy Prerequisites: Part 0'

## We want to take that risk
export PIP_BREAK_SYSTEM_PACKAGES=1

# Must go before everything else
report_progress 'Checking locale'
     locale | grep -q LANG=en_GB.UTF-8 || ( echo 'en_GB.UTF-8 is not set as the locale. You need to fix this before proceeding.' && exit 1 )
report_done
report_progress 'Checking for existence of SECRETS directory'
if [[ ! -d ~/.dotfiles/SECRETS ]] ; then
    echo "SECRETS directory does not exist.  Please create it and put your secrets in it. Running config tool:"
    ~/.dotfiles/bin/setup-secrets-dir.sh
fi
source ~/.dotfiles/SECRETS/vimz_config.sh
report_done
report_progress 'Creating ~/.secure directory'
    mkdir -p ~/.secure
report_done
report_progress 'Ensure home directory permissions are set securely'
   ~/.dotfiles/bin/secure-home-dir-perms.sh
report_done
report_progress 'Install Git'
    sudo apt-get install git -y
report_done
report_progress 'Install Make and g++'
    sudo apt-get install make g++ -y
report_done
# Backup and clean
report_progress 'Backing up existing dotfiles to ~/.olddotfiles'
    rm -rf ~/.olddotfiles
    mkdir -p ~/.olddotfiles
    cp -RL ~/.vim ~/.olddotfiles/.vim || echo "INFO: Could not backup .vim dir, does it exist?"
    cp -RL ~/.zsh* ~/.olddotfiles/ || echo "INFO: Could not backup .zsh*, do they exist?"
    cp -RL ~/.bash* ~/.olddotfiles/ || echo "INFO: Could not backup .bash*, do they exist?"
    cp -RL ~/.oh-my-zsh ~/.olddotfiles/ || echo "INFO: Could not backup .oh-my-zsh directory, does it exist?"
    cp -L ~/.bash_aliases ~/.olddotfiles/.bash_aliases || echo "INFO: Could not backup .bash_aliases, does it exist?"
    cp -L ~/.bash_profile ~/.olddotfiles/.bash_profile || echo "INFO: Could not backup .bash_profile, does it exist?"
    cp -L ~/.vimrc ~/.olddotfiles/.vimrc || echo "INFO: Could not backup .vimrc, does it exist?"
report_done
report_progress 'Removing existing zsh config'
    rm -f ~/.zshrc
    rm -f ~/.zshenv
    rm -rf ~/.oh-my-zsh
report_done
report_progress 'Removing existing vim config'
    rm -rf ~/.vim
report_done
report_progress 'Creating vim backup file directory structure'
    mkdir -p ~/.backup/vim/swap || echo "INFO: Swapfile backup directory seems to be already there."
    mkdir ~/.backup/vim/undos || echo "INFO: Undofile backup directory seems to be already there."
report_done
# Main lines
report_progress 'Upgrade all packages/distro to latest version'
    sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt-get upgrade -y && sudo apt-get autoremove -y
report_done
report_progress 'Check for Ubuntu release upgrade'
    sudo do-release-upgrade -c || echo 'No release upgraded needed.'
report_done
report_progress 'Installing snap'
    sudo apt install snapd
    sudo systemctl enable --now snapd apparmor
report_done
report_progress 'Download compile and install VIM9 on Ubuntu'
    sudo apt install libncurses-dev -y
    ~/.dotfiles/bin/make-and-install-vim.sh 9.1.0748 
report_done
report_progress 'Install Python used for vim plugins'
    sudo apt-get install python3 -y
    sudo apt-get install python3-pip -y
    pip install --upgrade pip # upgrade python2 (!) pip
    pip3 install --upgrade pip # upgrade python3
report_done
report_progress 'Install Rust and Cargo'
    curl https://sh.rustup.rs -sSfy | sh 
report_done
report_progress 'Install latest open JDK used for LanguageTool'
    sudo apt-get install default-jdk -y
report_done
report_progress 'Install Ruby, used for a few things'
    sudo apt-get install ruby -y
report_done
report_progress 'Install zsh the best shell (so far)'
    sudo apt-get install zsh -y
report_done
report_progress 'Install right type of Ctags used for vim plugins'
    sudo apt-get remove exuberant-ctags -y | true
    sudo apt-get install universal-ctags -y
report_done
report_progress 'Install net-tools used for network diagnostics'
    sudo apt-get install net-tools -y
report_done
report_progress 'Install fortune used for fortune cookie'
    sudo apt-get install fortune-mod -y
report_done
report_progress 'Install Ripgrewp used for :CocSearch'
    sudo apt-get install ripgrep -y
report_done
report_progress 'Install tree for showing directory structures'
    sudo apt-get install tree -y
report_done
report_progress 'Install w3m text browser for wikipedia2text'
    sudo apt-get install w3m -y
report_done
report_progress 'Install bat, a cat clone with syntax highlighting and Git integration'
    sudo apt-get install bat -y
report_done
report_progress 'Install curl for downloading from the web'
    sudo apt-get install curl -y
report_done
report_progress 'Install xclip and xsel for clipboard access'
    sudo apt-get install xclip xsel -y
report_done
report_progress 'Install tmux terminal multiplexer'
    sudo apt-get install tmux -y
report_done
report_progress 'Install Elixir for Elixir development'
    sudo apt-get install elixir erlang -y
report_done
report_progress 'Install Nmap for Network admin'
    sudo apt-get install nmap -y
report_done
report_progress 'Install asciicinema for screencasts'
    pip3 install asciinema
report_done
report_progress 'Install shfmt for shell script formatting'
    sudo apt-get install shfmt -y
report_done
report_progress 'Install shellcheck for shell script formatting'
    sudo apt-get install shellcheck -y
report_done
report_progress 'Install docker-compose'
    sudo apt-get install docker-compose  -y
report_done
report_progress 'Installing node'
if [[ $cur_os == 'windows' ]] ; then
    ~/.dotfiles/bin/install-node.sh
fi
if [[ $cur_os == 'linux' ]] ; then
    # for kali linux only
    ~/.dotfiles/bin/install-node.sh
fi
report_done
report_progress 'Install vint for vim script linting'
    pip3 install vint
report_done
report_progress 'Install write-good for markdown English betterment'
    sudo npm install -g write-good
report_done
report_progress 'Install markdownlint-cli for markdown English betterment'
    sudo npm install -g markdownlint-cli
report_done
report_progress 'Install yamllint'
    sudo apt install yamllint -y
report_done
report_progress 'Install jq'
    sudo apt install jq -y
report_done
report_progress 'Install Manchester Metrolink Commandline App for Tram times'
    cd ~/.dotfiles/bin
    wget https://github.com/ayubmalik/trams/releases/download/v1.2.0/trams-linux-amd64
    mv trams-linux-amd64 trams
    chmod u+x trams
report_done
#report_progress 'Install MozillaVPN for VPN privacy'
#    sudo add-apt-repository ppa:mozillacorp/mozillavpn -y
#    sudo apt-get update -y
#    sudo apt-get install mozillavpn -y
#report_done
report_progress 'Install chatgpt-cli comamnd line ChatGPT client'
    curl -L -o chatgpt https://github.com/kardolus/chatgpt-cli/releases/latest/download/chatgpt-linux-amd64 && chmod +x chatgpt && sudo mv chatgpt /usr/local/bin/
report_done
report_progress 'Install fnm node.js version manager'
    ~/.dotfiles/bin/install-fnm.sh
report_done
report_progress 'Install Joplin GUI desktop for integration with Browser plugin'
    if [[ $cur_os == 'linux' ]] ; then
      wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
    fi
report_done
# custom installation lines
report_progress 'Installing McFly, a zsh Control-R replacement'
    curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sudo sh -s -- --force --git cantino/mcfly
report_done
report_progress 'Installing Delta, a git diff viewer'
    wget https://github.com/dandavison/delta/releases/download/0.15.1/git-delta_0.15.1_amd64.deb
    sudo dpkg -i git-delta_0.15.1_amd64.deb
    rm git-delta_0.15.1_amd64.deb
report_done
report_progress 'Installing surfraw a command line google search client'
    sudo apt-get install surfraw surfraw-extra -y
report_done
report_progress 'Installing epy a command line epub reader'
    pip3 install git+https://github.com/wustho/epy
report_done
#report_progress 'Installing winbox wine snap'
 #   sudo snap refresh winbox || sudo snap install winbox
 #   sudo ufw allow 5678/udp
 #   sudo ufw reload
#report_done
report_progress 'Installing AWS CLI'
    ~/.dotfiles/bin/install-aws-cli.sh
report_done
report_progress 'Installing Rust and Cargo'
    sudo apt-get install cargo -y
report_done
report_progress 'We will now attempt to enable automated unattended-upgrades'
    sudo apt-get install unattended-upgrades -y
report_done
report_finished 'Deploy Prerequisites: Part 0 Complete'
