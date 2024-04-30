
set fish_greeting

function sudo
    command sudo -p "[sudo] password for $USER: " $argv
end

function n
    command nvim $argv
end

function g
    command lazygit $argv
end

function ls
    command eza --icons=always -a $argv
end

function t
    command tmux $argv
end

function ta
    command tmux attach -t $argv
end

function tl
    command tmux ls
end


function nf
    neofetch
end

# set red_color \#ec0101
set blue_color \#cb5be6
set cyan_color \#7d7cf9
# set -Ux LSCOLORS fxfxcxdxbxegedabagacad
function fish_prompt
    set_color $cyan_color
    echo -n "┌──("

    set_color --bold $blue_color
    echo -n "$USER@"(prompt_hostname)

    set_color normal
    set_color $cyan_color
    echo -n ")─["

    set_color normal
    set_color --bold
    echo -n (prompt_pwd)

    set_color normal
    set_color $cyan_color
    echo -n "]"
    echo ""

    set_color $cyan_color
    echo -n "└─"

    set_color --bold $blue_color
    echo -n "\$ "

    set_color normal
end

function postexec_test --on-event fish_postexec
    echo
end



# Homebrew
set -x PATH /opt/homebrew/bin $PATH

# Flutter
set -x PATH $PATH /Users/petchx/Development/flutter/bin

# COCOAPOD
set -x GEM_HOME $HOME/.gem
set -x PATH $GEM_HOME/bin $PATH

# SML
set -x PATH /usr/local/smlnj/bin $PATH
# set -x PATH /Users/petchx/.local/bin $PATH

export EDITOR=nvim
export VISUAL=nvim
source ~/.config/fish/lscolors.csh


if set -q ITERM_SESSION_ID; and test "$TERM_PROGRAM" = "iTerm.app"
    # nf
end

# run tmux from the start

zoxide init fish | source
# tmux

# Created by `pipx` on 2024-04-30 10:37:40
set PATH $PATH /Users/petchx/.local/bin

fish_add_path /Users/petchx/.spicetify
