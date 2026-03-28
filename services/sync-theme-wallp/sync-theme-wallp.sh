#!/bin/bash
set -euo pipefail

WALLP_DIR=$HOME/tools/dotfiles/themes/wallpapers
COSMIC_CONF_DIR=$HOME/.config/cosmic

LIGHT_WALLP=$WALLP_DIR/flexoki-light-orb.png
DARK_WALLP=$WALLP_DIR/flexoki-dark-orb.png

DARK_MODE_FILE=$COSMIC_CONF_DIR/com.system76.CosmicTheme.Mode/v1/is_dark
SET_WALLP_FILE=$COSMIC_CONF_DIR/com.system76.CosmicBackground/v1/all

if [[ $(cat $DARK_MODE_FILE) == "true" ]]; then
    WALLP=$DARK_WALLP
else
    WALLP=$LIGHT_WALLP
fi

sed -i "s|source: Path\(.*\)|source: Path(\"$WALLP\"),|" $SET_WALLP_FILE
