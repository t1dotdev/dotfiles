$env.EDITOR = "nvim"
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship" "starship.toml")
$env.SMLNJ_HOME = '/usr/local/smlnj'
# ANSI colors only, so the terminal theme picks a readable shade on light and dark.
$env.LS_COLORS = "di=34:ln=36:ex=32:or=31:tw=34:ow=34:st=34:pi=35:so=35:bd=35:cd=35"
$env.PATH = ($env.PATH | prepend '/usr/local/smlnj/bin' | append '/Users/topone/.bun/bin' | prepend '/opt/homebrew/opt/openjdk/bin' | prepend '/opt/homebrew/opt/python@3.13/libexec/bin' | append '/Users/topone/.opencode/bin')

zoxide init nushell | save -f ~/.zoxide.nu

