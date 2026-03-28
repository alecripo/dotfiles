#!/bin/bash
set -euo pipefail

BASE_DIR="$HOME/tools/dotfiles"

function sync_bash() {
    echo "Applying bash configs..."
    local bashfiles_dir="$BASE_DIR/bash"
    for file in "$bashfiles_dir"/*; do
        local target_name="$HOME/.$(basename "$file")"
        if [[ -f  "$target_name" || -L "$target_name" ]]; then
            if ! diff -q "$target_name" "$bashfiles_dir/$file" > /dev/null; then
                echo "$target_name already exists and differs; reconcile manually..."
            else
                echo "$target_name already synced; skipping..."
            fi
            continue
        fi
        echo -e "\t- creating symlink"
        ln -s "$bashfiles_dir/$file" "$target_name"
        echo -e "\t- done"
    done
}

function sync_cosmic() {
    echo "Syncing COSMIC configs..."

    local services_dir="$BASE_DIR/services"
    local unit_storage_path="$HOME/.config/systemd/user"
    if [[ -v XDG_CONFIG_HOME ]]; then
        unit_storage_path="$XDG_CONFIG_HOME/systemd/user"
    fi

    if [[ ! -d $unit_storage_path ]]; then
        mkdir -p "$unit_storage_path"
    fi
    if [[ ! -d $HOME/.local/bin ]]; then
        mkdir -p "$HOME/.local/bin"
    fi
    if [[ ! -d $HOME/.local/share/services/envs ]]; then
        mkdir -p "$HOME/.local/share/services/envs"
    fi


    ln -s "$services_dir/sync-theme-wallp/sync-theme-wallp.path" "$unit_storage_path/"
    ln -s "$services_dir/sync-theme-wallp/sync-theme-wallp.service" "$unit_storage_path/"
    ln -s "$services_dir/sync-theme-wallp/sync-theme-wallp.env" "$HOME/.local/share/services/envs/"
    ln -s "$services_dir/sync-theme-wallp/sync-theme-wallp.sh" "$HOME/.local/bin/sync-theme-wallp"
    chmod +x "$HOME/.local/bin/sync-theme-wallp"

    systemctl --user daemon-reload
    systemctl --user enable sync-theme-wallp.path
    systemctl --user start sync-theme-wallp.path
}

sync_cosmic
sync_bash
