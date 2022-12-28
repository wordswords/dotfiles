#!/bin/bash
# vim: spell set nowrap

set -e
source ./deploy-common.sh


report_heading 'Deploy Prerequisites: Part 0'

# apt-get lines
report_progress 'Upgrade all packages/distro to latest version'
    sudo apt update -y && sudo apt dist-upgrade -y && sudo apt upgrade -y && sudo apt autoremove -y
report_done
report_progress 'Upgrade VIM to latest version using third-party repo'
    sudo add-apt-repository ppa:jonathonf/vim -y
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install vim-gtk3 -y || sudo apt upgrade vim-gtk3 -y
report_done
report_progress 'Install Speedtest from ookla for testing network speed'
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
    sudo apt-get install speedtest -y
report_done
report_progress 'Install Git'
    sudo apt install git -y
report_done
report_progress 'Install Python 3 used for vim plugins'
    sudo apt install python3 -y
    sudo apt install python3-pip -y
report_done
report_progress 'Install latest open JDK used for LanguageTool'
    sudo apt install default-jdk -y
report_done
report_progress 'Install zsh the best shell (so far)'
    sudo apt install zsh -y
report_done
report_progress 'Install Ctags used for vim-fugitive'
    sudo apt install universal-ctags -y
report_done
report_progress 'Install net-tools used for network diagnostics'
    sudo apt install net-tools -y
report_done
report_progress 'Install fortune used for fortune cookie'
    sudo apt install fortune-mod -y
report_done
report_progress 'Install Ripgrewp used for :CocSearch'
    sudo apt install ripgrep -y
report_done
report_progress 'Install tree for showing directory structures'
    sudo apt install tree -y
report_done
report_progress 'Install w3m text browser for wikipedia2text'
    sudo apt install w3m -y
report_done
report_progress 'Install  bat, a cat clone with syntax highlighting and Git integration'
    sudo apt install bat -y
report_done
report_progress 'Install curl for downloading from the web'
    sudo apt install curl -y
report_done
report_progress 'Install xclip and xsel for clipboard access'
    sudo apt install xclip xsel -y
report_done

# custom installation lines
report_progress 'Installing McFly, a zsh Control-R replacement'
    curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --force --git cantino/mcfly
report_done

report_progress 'Installing Delta, a git diff viewer'
    wget https://github.com/dandavison/delta/releases/download/0.15.1/git-delta_0.15.1_amd64.deb
    sudo dpkg -i git-delta_0.15.1_amd64.deb
    rm git-delta_0.15.1_amd64.deb
report_done

report_progress 'Installing cht.sh a command line help client'
    PATH_DIR="$HOME/bin"  # or another directory on your $PATH
    mkdir -p "$PATH_DIR"
    curl https://cht.sh/:cht.sh > "$PATH_DIR/cht.sh"
    chmod +x "$PATH_DIR/cht.sh"
report_done

# os-specific lines
cur_os=get_os
if [[ cur_os == 'ubuntu' || cur_os == 'osx' ]];
then
    report_progress 'Installing vim-anywhere for allowing text to be edited on any text input'
        curl -fsSL https://raw.github.com/cknadler/vim-anywhere/master/install | bash
    report_done
fi
if [[ cur_os == 'ubuntu' ]];
then
    report_progress 'Installing workrave, a reminder app to take screenbreaks'
        sudo apt install workrave -y
    report_done

    report_progress 'Install cool-retro-term for a great terminal'
        sudo apt install cool-retro-term -y
    report_done
fi

# ui-dependant lines
report_progress 'We will now attempt to enable automated unattended-upgrades'
    sudo apt install unattended-upgrades
    sudo dpkg-reconfigure unattended-upgrades
report_done

report_finished 'Deploy Prerequisites: Part 0 Complete'

