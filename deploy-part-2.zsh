#!/bin/bash
# vim: foldmethod=marker foldmarker=report_progress,report_done

## To be run after the previous two deploy scripts

# Load in status message printing functions
set -e
set -x
source ./deploy-common.sh

# Load in vimz config variables
source ~/.dotfiles/SECRETS/vimz_config.sh

## We want to take that risk
export PIP_BREAK_SYSTEM_PACKAGES=1

report_heading 'Deploy Dotfiles: Part 2'
report_progress 'Testing Github access'
ssh -T git@github.com 2>/tmp/githubaccesscheck.txt || echo ""
grep 'successfully authenticated' /tmp/githubaccesscheck.txt || (echo ERROR: Github acccess not available && exit 1)
rm /tmp/githubaccesscheck.txt
report_done
## Backup existing config and set links to new
report_progress 'Removing existing dotfiles'
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.bash_profile
rm -f ~/.vim/coc-settings.json
report_done
report_progress 'Installing oh-my-zsh plugins'
cd ~/.oh-my-zsh/plugins &&
	(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git &&
		git clone https://github.com/zsh-users/zsh-autosuggestions.git &&
		git clone https://github.com/agkozak/zsh-z.git &&
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && yes | ~/.fzf/install) ||
	echo "INFO: OMZ plugins already seem to be installed."
report_done
report_progress 'Removing default ~/.zshrc directory'
rm -rf ~/.zshrc #remove the default .zshrc generated by the oh-my-zsh install
report_done
report_progress 'Setting up local bin directory'
rm -rf ~/bin
mkdir -p ~/bin
cp -furs ~/.dotfiles/bin/* ~/bin/
report_done
report_progress 'Setting up symbolic links'
mkdir -p ~/.dotfiles/.vim
ln --force -s ~/.dotfiles/.vim ~/.vim
ln --force -s ~/.dotfiles/.bash_aliases ~/.bash_aliases
ln --force -s ~/.dotfiles/.bash_aliases ~/.zsh_aliases
ln --force -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln --force -s ~/.dotfiles/.bash_profile_remote ~/.bash_profile_remote
ln --force -s ~/.dotfiles/coc-settings.json ~/.vim/coc-settings.json
ln --force -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln --force -s ~/.dotfiles/.vimrc ~/.vimrc
ln --force -s ~/.dotfiles/.zshenv ~/.zshenv
ln --force -s ~/.dotfiles/.zshrc ~/.zshrc
ln --force -s -n ~/.dotfiles/.vim ~/.vim
report_done
report_progress 'Running ctags'
ctags -R ./*
report_done
report_progress 'Installing bash-language-server through npm'
sudo npm install -g bash-language-server
report_done
report_progress 'Install Texidote grammar checker'
cd ~/.dotfiles
rm -rf ./*.jar
~/.dotfiles/bin/download-latest-texidote-jar.sh
cd -
report_done
report_progress 'Install wikipedia2text'
cd ~/.dotfiles
rm -rf ./wikipedia2text || true
cd ~/.dotfiles && git clone git@github.com:chrisbra/wikipedia2text.git
ln -sf ~/.dotfiles/wikipedia2text/wikipedia2text ~/.dotfiles/bin/wp2t
cd -
report_done
## General Install
report_progress 'Running ctags'
ctags -R ./*
report_done
report_progress 'Installing bash-language-server through npm'
sudo npm install -g bash-language-server
report_done
report_progress 'Install wikipedia2text'
cd ~/.dotfiles
rm -rf ./wikipedia2text || true
cd ~/.dotfiles && git clone git@github.com:chrisbra/wikipedia2text.git
ln -sf ~/.dotfiles/wikipedia2text/wikipedia2text ~/.dotfiles/bin/wp2t
cd -
report_done
report_progress 'Installing Powerlevel10k prompt'
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k || true
ln --force -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh || true
report_done
report_progress  'Installing Vundle for vim'
rm -rf ~/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
report_done
report_progress 'Running vim local commands for plugins'
echo '''
    :PluginClean
    :PluginInstall
    :Copilot setup
    :helptags ALL
    :qa
    ''' >~/.dotfiles/vimscript.vs
vim -s ~/.dotfiles/vimscript.vs
rm ~/.dotfiles/vimscript.vs
report_done
read -rp "Do you want to install/update YouCompleteMe for VIM9 (takes a long time on slower systems) (y/yes/N)? " YCMINSTALL
case "$YCMINSTALL" in
    Y|y|yes)
        report_progress 'Download, install and compile YouCompleteMe for VIM9'
        ~/.dotfiles/bin/deploy-ycm.sh
    ;;
    *)
        echo ''
    ;;
esac
report_progress 'Register YCM Plugin Install for Vim9'
echo '''
    :PluginInstall
    :qa
    ''' >~/.dotfiles/vimscript.vs
vim -s ~/.dotfiles/vimscript.vs
rm ~/.dotfiles/vimscript.vs
report_done
report_progress 'Installing Github Copilot VIM9 plugin'
rm -rf ~/.vim/pack/github/start/copilot.vim
git clone git@github.com:github/copilot.vim.git ~/.vim/pack/github/start/copilot.vim
report_done
report_progress 'Installing vim colorscheme'
git clone git@github.com:shannonmoeller/vim-monokai256.git ./colorscheme
mkdir -p ~/.vim/colors/
mv ./colorscheme/colors/* ~/.vim/colors/
rm -rf ./colorscheme
report_done
report_progress 'Installing pynvim for python integration with vim'
pip3 install --user pynvim
pip3 install jedi
report_done
report_progress 'Setting default git config..'
rm ~/.gitconfig
cp ~/.dotfiles/.gitconfig ~/.gitconfig
set -x
git config --global user.email "${VIMZ_EMAIL}"
set +x
report_done
report_progress 'Installing and configuring Joplin CLI notetaking app'
~/.dotfiles/bin/update-joplin-cli.sh
joplin-cli config --import-file ~/.dotfiles/joplin.config
report_done
report_progress 'Changing shell to /bin/zsh.'
sudo chsh -s "$(which zsh)" "$(whoami)"
report_done
report_progress 'Customising Fortune random quoter'
sudo rm -rf /usr/share/games/fortunes/* || true
sudo tar xzf ~/.dotfiles/gaiman-fortunes.tgz -C /usr/share/games/fortunes/
report_done
report_progress 'Stop unwanted changes dirtying up the dotfiles commit tracking'
~/bin/clean-git-checkout.sh ~/.dotfiles/.vim/pack/plugins/start/ || true
git restore --staged ~/.vim || true
report_done
report_progress 'Installing tmux plugin manager'
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || cd ~/.tmux/plugins/tpm && git pull && cd -
report_done
report_progress 'Installing tmuxinator'
sudo chown -R ${VIMZ_USER} /var/lib/gems || true
sudo gem install tmuxinator
report_done
report_progress 'Configuring tmuxinator'
mkdir -p ~/.config/tmuxinator
ln --force -s ~/.dotfiles/development.yml ~/.config/tmuxinator/development.yml
report_done

## OS specific stuff
cur_os=$(get_os)
report_progress 'Running any Windows specific configuration'
if [[ $cur_os == 'windows' ]] ; then
    # install windows tools
    git clone git@github.com:wordswords/windows-tools.git ~/.dotfiles/windows-tools

    # install alacritty
    ~/.dotfiles/windows-tools/windows-terminal-emulators-config/install-alacritty-windows.sh

    # install win32yank
    cp ~/.dotfiles/windows-tools/windows-clipboard/win32yank.exe ~/.bin
fi
report_done
report_progress 'Running any Linux specific configuration'

if [[ $cur_os == 'linux' ]] ; then

    # install alacritty
    ~/.dotfiles/linux-terminal-emulators-config/install-alacritty-linux.sh

    # disable touchpad tap to click
	gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click false
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

    # sync clipboards on ubuntu
    python3 ~/.dotfiles/bin/sync-clipboards-ubuntu.py

	echo
	echo "-- OPTIONAL EXTRAS -- "
	echo

    read -rp "Do you want to benchmark your computer with hardinfo2 (equiv to Speccy)? (y/yes/N)? " HB2INSTALL
    case "$HB2INSTALL" in
        Y|y|yes)
            ~/.dotfiles/bin/install-hardinfo2.sh
        ;;
        *)
            true
        ;;
    esac

    read -rp "Do you want to install/update JIRA-CLI Go client? (y/yes/N)? " JIRAINSTALL
    case "$JIRAINSTALL" in
        Y|y|yes)
            sudo snap install go --classic 2>/dev/null || sudo snap refresh go
            go install golang.org/dl/go1.19@latest
            go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest
        ;;
        *)
            # remove go jira client if it was installed previously
            rm ~/go/bin/jira &>/dev/null || true
        ;;
    esac

	read -rp "Do you want to install/update the Ubuntu snap images of Morgen and Firefox? (y/yes/N)? " SNAPINSTALL
    case "$SNAPINSTALL" in
        Y|y|yes)
            sudo snap install morgen 2>/dev/null || sudo snap refresh morgen
            sudo snap install firefox 2>/dev/null || sudo snap refresh firefox
        ;;
        *)
            true
        ;;
    esac
fi
report_done
report_progress "Outputting 24-bit console colour test - there should be no banding!"
~/.dotfiles/bin/24-bit-color.sh
report_done
report_progress "Deploy Process: Complete"
echo
echo "-- NEXT STEPS -- "
echo
echo '''
You will have to install your nerdfont manually, download
DroidSansNerdFontMono from https://github.com/ryanoasis/nerd-fonts
here: https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/DroidSansMono/complete

After this, you will have to set your terminal emulator to use
said font.

Alacritty is installed and configured and it is the recommended terminal emulator, so do whatever it is needed to change your usual terminal shortcut to point to it.
'''
report_done
report_heading 'All Done.'
