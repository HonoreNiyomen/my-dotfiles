Horez Dotfiles
<p align="center"> <img src="screenshot_2025-08-13_13:32:42.png" alt="screenshot — sway + wayland on Debian" width="85%"> </p>

A curated set of my desktop configuration files (Sway / Wayland focused) — themes, bar configs, and small helper scripts to get a clean, minimal, and visually consistent environment.
About

This repo contains my personal dotfiles and UI configs. The screenshot above shows the setup running on Sway + Wayland (Debian). These files are intended to be opinionated, minimal, and easy to tweak.

Key components included:

    sway (WM)

    waybar (status bar)

    wofi / rofi (launchers)

    kitty / alacritty (terminals)

    polybar (legacy configs included)

    picom (compositor configs)

    dunst (notifications)

    fastfetch (welcome info)

Configs live under .config/ in the repo and are grouped per-app for easy inspection.
Install notes

    These are notes only — not a step-by-step install. Back up your existing configs before applying anything.

    Clone the repo to your machine.

    This setup assumes a Wayland environment (Sway) — some configs are also compatible with i3 (legacy).

    Icon theme and GTK theme affect the look of wofi / GTK apps — install a proper icon theme (e.g. Papirus) if you want icons to show.

    There are small helper docs under runs/inits/ (e.g. ssh.md, zsh.md) with quick notes for those components.

    Files removed or replaced in the current working tree are intentional (see commit history) — review before applying.

Quick examples (summary)

    Clone:

git clone https://github.com/HonoreNiyomen/my-dotfiles.git
cd my-dotfiles

    Back up your existing ~/.config before copying/symlinking.

    You can deploy by copying or symlinking specific app folders from .config/ into your ~/.config/.

What’s in this repo

LICENSE
runs/               # small notes & init docs
screenshot_2025-08-13_13:32:42.png
Wallpaper.jpg
.config/
  ├─ alacritty
  ├─ fastfetch
  ├─ kitty
  ├─ polybar
  ├─ sway
  ├─ wofi
  ├─ dunst
  ├─ i3
  ├─ picom
  ├─ rofi
  └─ waybar

Tips

    Review sway/config and waybar/config to match your hardware (monitor names, audio devices, network).

    If icons in wofi are missing, check your system icon theme and confirm .desktop files have Icon= entries.

    Use the runs/inits notes if you want quick reminders for SSH/Zsh setup.

Contributing & Contact

If you want to suggest visual tweaks or small improvements, open an issue or a PR. I maintain these files primarily for my own use, but friendly tweaks are welcome.
License

This repo is licensed under the terms in LICENSE.
