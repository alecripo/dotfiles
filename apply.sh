#!/bin/bash
set -euo pipefail
function sync_bash() {
    echo "Applying bash configs..."
    local bashfiles_dir="$PWD/bash"
    for file in $(ls "$bashfiles_dir"); do
        local target_name="$HOME/.$file"
        if [[ -f  "$target_name" || -L "$target_name" ]]; then
            echo "$target_name already exists;"
            echo -e "\t- removing"
            rm "$target_name"
        fi
        echo -e "\t- creating symlink"
        ln -s "$bashfiles_dir/$file" "$target_name"
        echo -e "\t- done"
    done
}

sync_bash