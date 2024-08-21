autoload -Uz compinit
compinit
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jbm/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jbm/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jbm/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jbm/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# zoxide setup
eval "$(zoxide init zsh)"
alias cd="z"
# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
source <(fzf --zsh)

# added for ls colors on macos
export CLICOLOR=1

# init oh my post prompt
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/zen.toml)"
fi

export PATH="/opt/homebrew/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/bin:$PATH"

export GOPATH="$HOME/go"

export PATH="$HOME/go/bin:$PATH"

export PATH="/opt/homebrew/opt/node@16/bin:$PATH"

export PATH="$HOME/bin/clickhouse-server/usr/bin:$PATH"

export PATH="$HOME/bin/clickhouse-server/usr/local/bin:$PATH"

export GOROOT="/opt/homebrew/opt/go@1.20/libexec"

export PATH="/opt/homebrew/opt/go@1.20/libexec/bin:$PATH"

export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
