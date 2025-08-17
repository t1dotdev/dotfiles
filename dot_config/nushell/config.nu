
# Aliases
alias n = nvim
alias g = lazygit

alias t = tmux
alias ta = tmux attach
alias tk = tmux kill-session -t
alias tka = tmux kill-server


# Starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.zoxide.nu
$env.PROMPT_COMMAND = {|| 
    let dir = ($env.PWD | str replace $nu.home-path "~")
    $"(ansi green_bold)($dir)(ansi reset)\n\n> "
}

