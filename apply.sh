#!/bin/bash
set -euo pipefail

BASE_DIR="$HOME/tools/dotfiles"

function check_link_exists() {
    local link_name="$1"

    if [[ -L "$link_name" ]]; then
        echo "$link_name already synced; skipping..."
        return 0
    fi

    return 1
}

function sync_bash() {
    echo "Applying bash configs..."
    local bashfiles_dir="$BASE_DIR/bash"
    for file in "$bashfiles_dir"/*; do
        local target_name="$HOME/.$(basename "$file")"
        if (check_link_exists "$target_name"); then
            continue
        fi
        echo -e "\t- creating symlink"
        ln -s "$bashfiles_dir/$file" "$target_name"
        echo -e "\t- done"
    done
}

function sync_change_wallp_theme() {
    local service_dir="$BASE_DIR/sync-theme-wallp/services"
    local unit_storage_path="$HOME/.config/systemd/user"

    if (! check_link_exists "$unit_storage_path/sync-theme-wallp.path"); then
        ln -s "$service_dir/sync-theme-wallp.path" "$unit_storage_path/"
    fi

    if (! check_link_exists "$unit_storage_path/sync-theme-wallp.service"); then
        ln -s "$service_dir/sync-theme-wallp.service" "$unit_storage_path/"
    fi

    if (! check_link_exists "$HOME/.local/share/services/envs/sync-theme-wallp.env"); then
        ln -s "$service_dir/sync-theme-wallp.env" "$HOME/.local/share/services/envs/"
    fi

    if (! check_link_exists "$HOME/.local/bin/sync-theme-wallp"); then
        ln -s "$service_dir/sync-theme-wallp.sh" "$HOME/.local/bin/sync-theme-wallp"
    fi
    chmod +x "$HOME/.local/bin/sync-theme-wallp"

    systemctl --user daemon-reload
    systemctl --user enable sync-theme-wallp.path
    systemctl --user start sync-theme-wallp.path
}

function sync_cosmic() {
    echo "Syncing COSMIC configs..."

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

    sync_change_wallp_theme

}

sync_bash
sync_cosmic
