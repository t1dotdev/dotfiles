$env.EDITOR = "nvim"
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship" "starship.toml")
$env.PATH = ($env.PATH | prepend '/usr/local/smlnj/bin' | append '/Users/topone/.bun/bin')

zoxide init nushell | save -f ~/.zoxide.nu

