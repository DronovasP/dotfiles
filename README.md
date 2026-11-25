# dotfiles

Managed with [chezmoi](https://chezmoi.io). Targets Omarchy (Arch + Hyprland) and macOS.

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply DronovasP
# or, with chezmoi already installed:
chezmoi init --apply DronovasP
```

Day to day:

```sh
chezmoi re-add          # pull edits made in ~/.config back into the repo
chezmoi diff            # preview what apply would change
chezmoi apply           # write repo -> ~/.config
chezmoi cd && git push  # publish
```

## Omarchy notes

- `~/.config/hypr/hyprland.lua` is **not** tracked. Omarchy owns it. Only the
  override files are tracked: `input.lua` (flat mouse accel, -0.5 sensitivity),
  `bindings.lua` (Alt+Space -> Vicinae), `monitors.lua` (stacked monitors, matched by description).
- `run_onchange_before_10-install-packages.sh` installs packages from
  `.chezmoidata/packages.yaml` (pacman + yay on Arch, brew on macOS).
- Monocraft font is downloaded by `.chezmoiexternal.toml.tmpl` into `~/.local/share/fonts`.
- `run_onchange_after_30-keyd.sh` copies `~/.config/keyd/default.conf` to `/etc/keyd/` (Caps: tap = Esc, hold = Super).
- `run_onchange_after_20-services.sh` enables `vicinae.service` and reloads Hyprland.
- waybar is ignored (Omarchy uses its own bar); aerospace only applies on macOS.
