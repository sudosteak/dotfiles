#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_file() {
    local src="$DOTFILES_DIR/$1"
    local dest="$2"
    local dest_dir
    dest_dir=$(dirname "$dest")

    if [ ! -e "$src" ]; then
        echo "Skipping $src (does not exist)"
        return
    fi

    mkdir -p "$dest_dir"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up existing $dest"
        mv "$dest" "$dest.bak"
    fi

    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    ln -s "$src" "$dest"
    echo "Linked $src -> $dest"
}

link_dir() {
    local src="$DOTFILES_DIR/$1"
    local dest="$2"

    if [ ! -d "$src" ]; then
        echo "Skipping $src (does not exist)"
        return
    fi

    mkdir -p "$dest"

    for item in "$src"/*; do
        [ -e "$item" ] || continue
        local item_name
        item_name=$(basename "$item")
        link_file "$1/$item_name" "$dest/$item_name"
    done
}

link_file "bash/bashrc" "$HOME/.bashrc"
link_dir "bash/bash" "$HOME/.bash"

link_file "alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
link_file "alacritty/opencode-theme.toml" "$HOME/.config/alacritty/opencode-theme.toml"

link_file "ghostty/config" "$HOME/.config/ghostty/config"
link_dir "ghostty/themes" "$HOME/.config/ghostty/themes"

link_file "kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

link_file "tmux/tmux.conf" "$HOME/.tmux.conf"

link_file "nvim/init.lua" "$HOME/.config/nvim/init.lua"
link_file "nvim/.luarc.json" "$HOME/.config/nvim/.luarc.json"
link_dir "nvim/lua" "$HOME/.config/nvim/lua"
link_dir "nvim/after" "$HOME/.config/nvim/after"

link_file "fish/config.fish" "$HOME/.config/fish/config.fish"
link_file "fish/fish_variables" "$HOME/.config/fish/fish_variables"
link_dir "fish/functions" "$HOME/.config/fish/functions"
link_dir "fish/completions" "$HOME/.config/fish/completions"
link_dir "fish/conf.d" "$HOME/.config/fish/conf.d"

link_file "zed/settings.json" "$HOME/.config/zed/settings.json"
link_dir "zed/themes" "$HOME/.config/zed/themes"
link_dir "zed/testing" "$HOME/.config/zed/testing"

echo "Done!"
