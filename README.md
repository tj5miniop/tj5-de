# tj5-de

## Needs to be added
- A polkit agent 
- An idle/lock manager (e.g. `swayidle` + a lock screen)
- `xdg-desktop-portal-wlr` for screen sharing

## To install
```sh
cp -r .config/labwc .config/quickshell ~/.config/
cp .config/labwc/themerc-override ~/.config/labwc/themerc-override
```
Make sure `labwc`, `quickshell`, `wofi`, and a terminal (`ghostty` or
`alacritty`) are actually installed and on `$PATH` — none of this can start
anything that isn't present on the system.
