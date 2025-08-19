

let theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: { fg: '#ffffff' attr: b } # bold headerb 
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'light_cyan' } else { 'light_gray' } }
    bool: light_cyan
    int: white
    filesize: "#875aff"
    duration: white
    date: white
    range: white
    float: white
    string: "#ffffff"
    nothing: white
    binary: white
    cell-path: white
    row_index: { fg: '#ffffff' attr: b } # bold row index
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: { bg: red fg: white }
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_yellow_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b}
    shape_glob_interpolation: cyan_bold
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
}

$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.config = {
    # Set the theme for Nushell
    #
    color_config: $theme
    edit_mode: "vi" # or "emacs"
    show_banner: false
    ls: {
        use_ls_colors: true # use the LS_COLORS environment variable to colorize output
        clickable_links: true # enable or disable clickable links. Your terminal has to support links.
    }
    table: {
      mode: rounded
    }


}


# Aliases
alias n = nvim
alias g = lazygit
# alias ip = (sys net | where ip != [] | each {|interface| $interface.ip | each {|ip| {name: $interface.name, ip: $ip.address}}} | flatten)

def ip [] {
    sys net | where ip != [] | each {|interface| 
        $interface.ip | each {|ip| 
            {
                name: ($interface.name | fill --alignment left --width 10 | $"(ansi purple)($in)(ansi reset)")
                ip: $ip.address
            }
        }
    } | flatten
}

alias t = tmux
alias tl = tmux list-sessions
alias ta = tmux attach -t
alias tk = tmux kill-session -t
alias tka = tmux kill-server


# Starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.zoxide.nu
alias cd = z
