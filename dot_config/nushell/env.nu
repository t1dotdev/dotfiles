$env.EDITOR = "nvim"
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship" "starship.toml")
$env.SMLNJ_HOME = '/usr/local/smlnj'
$env.PATH = ($env.PATH | prepend '/usr/local/smlnj/bin' | append '/Users/topone/.bun/bin' | prepend '/opt/homebrew/opt/openjdk/bin' | prepend '/opt/homebrew/opt/python@3.13/libexec/bin' | append '/Users/topone/.opencode/bin')

zoxide init nushell | save -f ~/.zoxide.nu

