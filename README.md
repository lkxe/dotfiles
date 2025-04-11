# My dotfiles

## Prerequisites
### Required
- Arch Linux
- Hyprland
- Tuckr
- sww (for wallpapers)

### Optional
- ghostty
- eww
- fastfetch
- zsh
- thunar
- fuzzel

## Installation
Make sure (Tuckr)[https://github.com/RaphGL/Tuckr] is installed

1. Clone this repository into your home folder
```bash
git clone https://github.com/lkxe/dotfiles ~/.dotfiles
```
2. Symlink the dotfiles
```bash
tuckr add \*
```
3. Check everything is working, otherwise you already have existing config files. Remove them if necessary
```bash
tuckr status
```
4. You will most likely have to set the wallpaper using sww
```bash
swww img /link/to/wallpaper.jpg
```
