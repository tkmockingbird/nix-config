{pkgs, ...}: {
  programs = {
    nushell = {
      enable = true;
      extraConfig = ''
        let carapace_completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
        }
        $env.config = {
          show_banner: false,
          completions: {
            case_sensitive: false # case-sensitive completions
            quick: true    # set to false to prevent auto-selecting completions
            partial: true    # set to false to prevent partial filling of the prompt
            algorithm: "fuzzy"    # prefix or fuzzy
            external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
              # set to lower can improve completion performance at the cost of omitting some options
              max_results: 200
              completer: $carapace_completer # check 'carapace_completer'
            }
          }
        }
        $env.PATH = ($env.PATH |
        split row (char esep) |
        prepend /home/myuser/.apps |
        append /usr/bin/env
        )

        # Theme configuration
        def theme_main [] {
          {
            # Theme color definitions here (copy from the provided script)
            binary: '#c678dd'
            block: '#61afef'
            cell-path: '#abb2bf'
            closure: '#56b6c2'
            custom: '#fffefe'
            duration: '#d19a66'
            float: '#e06c75'
            glob: '#fffefe'
            int: '#c678dd'
            list: '#56b6c2'
            nothing: '#e06c75'
            range: '#d19a66'
            record: '#56b6c2'
            string: '#98c379'

            bool: {|| if $in { '#56b6c2' } else { '#d19a66' } }

            date: {|| (date now) - $in |
                if $in < 1hr {
                    { fg: '#e06c75' attr: 'b' }
                } else if $in < 6hr {
                    '#e06c75'
                } else if $in < 1day {
                    '#d19a66'
                } else if $in < 3day {
                    '#98c379'
                } else if $in < 1wk {
                    { fg: '#98c379' attr: 'b' }
                } else if $in < 6wk {
                    '#56b6c2'
                } else if $in < 52wk {
                    '#61afef'
                } else { 'dark_gray' }
            }

            filesize: {|e|
                if $e == 0b {
                    '#abb2bf'
                } else if $e < 1mb {
                    '#56b6c2'
                } else {{ fg: '#61afef' }}
            }

            shape_and: { fg: '#c678dd' attr: 'b' }
            shape_binary: { fg: '#c678dd' attr: 'b' }
            shape_block: { fg: '#61afef' attr: 'b' }
            shape_bool: '#56b6c2'
            shape_closure: { fg: '#56b6c2' attr: 'b' }
            shape_custom: '#98c379'
            shape_datetime: { fg: '#56b6c2' attr: 'b' }
            shape_directory: '#56b6c2'
            shape_external: '#56b6c2'
            shape_external_resolved: '#56b6c2'
            shape_externalarg: { fg: '#98c379' attr: 'b' }
            shape_filepath: '#56b6c2'
            shape_flag: { fg: '#61afef' attr: 'b' }
            shape_float: { fg: '#e06c75' attr: 'b' }
            shape_garbage: { fg: '#FFFFFF' bg: '#FF0000' attr: 'b' }
            shape_glob_interpolation: { fg: '#56b6c2' attr: 'b' }
            shape_globpattern: { fg: '#56b6c2' attr: 'b' }
            shape_int: { fg: '#c678dd' attr: 'b' }
            shape_internalcall: { fg: '#56b6c2' attr: 'b' }
            shape_keyword: { fg: '#c678dd' attr: 'b' }
            shape_list: { fg: '#56b6c2' attr: 'b' }
            shape_literal: '#61afef'
            shape_match_pattern: '#98c379'
            shape_matching_brackets: { attr: 'u' }
            shape_nothing: '#e06c75'
            shape_operator: '#d19a66'
            shape_or: { fg: '#c678dd' attr: 'b' }
            shape_pipe: { fg: '#c678dd' attr: 'b' }
            shape_range: { fg: '#d19a66' attr: 'b' }
            shape_raw_string: { fg: '#fffefe' attr: 'b' }
            shape_record: { fg: '#56b6c2' attr: 'b' }
            shape_redirection: { fg: '#c678dd' attr: 'b' }
            shape_signature: { fg: '#98c379' attr: 'b' }
            shape_string: '#98c379'
            shape_string_interpolation: { fg: '#56b6c2' attr: 'b' }
            shape_table: { fg: '#61afef' attr: 'b' }
            shape_vardecl: { fg: '#61afef' attr: 'u' }
            shape_variable: '#c678dd'

            foreground: '#5c6370'
            background: '#1e2127'
            cursor: '#5c6370'

            empty: '#61afef'
            header: { fg: '#98c379' attr: 'b' }
            hints: '#5c6370'
            leading_trailing_space_bg: { attr: 'n' }
            row_index: { fg: '#98c379' attr: 'b' }
            search_result: { fg: '#e06c75' bg: '#abb2bf' }
                separator: '#abb2bf'
          }
        }
        # Update the Nushell configuration with the theme
        $env.config.color_config = (theme_main)

        # Function to update terminal colors
        def update_terminal [] {
          let theme = (theme_main)
          let osc_screen_foreground_color = '10;'
          let osc_screen_background_color = '11;'
          let osc_cursor_color = '12;'

          $"(ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)(ansi -o $osc_screen_background_color)($theme.background)(char bel)(ansi -o $osc_cursor_color)($theme.cursor)(char bel)"
          | str replace --all "\n" '''
          | print -n $"($in)\r"
        }

        # Activate the theme
        update_terminal
      '';
      shellAliases = {
        vi = "micro";
        vim = "micro";
        nano = "micro";
        upgit = "/home/$(whoami)/nix-config/gitupdate.sh";
        update = "/home/$(whoami)/nix-config/update.sh";
        garbage = "sudo nix-collect-garbage -d";
        upflake = "cd /home/$(whoami)/nix-config && nix flake update && cd ~";
      };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
}
