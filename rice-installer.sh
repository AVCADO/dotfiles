#!/bin/sh

# Make directories
mkdir -vp ~/.config/{openbox,alacritty,tint2}
mkdir -vp ~/.themes/Lean/openbox-3

# Copy files

# Copy openbox theme over
cp -v openbox/theme/* ~/.themes/Lean/openbox-3/

# Copy alacritty config over
cp -v alacritty/alacritty.yml ~/.config/alacritty/

# Copy tint2 config over
cp -v tint2/* ~/.config/tint2

# Copy openbox config over
cp -v openbox/settings/* ~/.config/openbox/

echo Done.
