$env.EDITOR = "nvim"
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship" "starship.toml")
$env.PATH = ($env.PATH | append '/Users/topone/.bun/bin')

zoxide init nushell | save -f ~/.zoxide.nu

