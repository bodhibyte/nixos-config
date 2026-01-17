# Home-manager modules adapted for ARM64
# Excludes x86-only packages: spicetify (Spotify), retroarch, gaming
{ ... }:
{
  imports = [
    ./../../modules/home/aseprite/aseprite.nix
    ./../../modules/home/audacious/audacious.nix
    ./../../modules/home/bat.nix
    ./../../modules/home/browser.nix
    ./../../modules/home/btop.nix
    ./../../modules/home/cava.nix
    ./../../modules/home/discord.nix
    ./../../modules/home/fastfetch/fastfetch.nix
    ./../../modules/home/fzf.nix
    # ./../../modules/home/gaming.nix          # x86-only
    ./../../modules/home/ghostty/ghostty.nix
    ./../../modules/home/git.nix
    ./../../modules/home/gnome.nix
    ./../../modules/home/gtk.nix
    ./../../modules/home/hyprland
    ./../../modules/home/kitty.nix
    ./../../modules/home/lazygit.nix
    ./../../modules/home/micro.nix
    ./../../modules/home/nemo.nix
    ./../../modules/home/nvim.nix
    ./../../modules/home/obsidian.nix
    ./../../modules/home/p10k/p10k.nix
    # ./../../modules/home/packages   # Contains x86-only packages
    ./../../modules/home/packages/cli.nix
    ./../../modules/home/packages/dev.nix
    ./../../modules/home/packages/nix.nix
    ./gui-arm64.nix
    ./../../modules/home/pomo/pomo.nix
    # ./../../modules/home/retroarch.nix       # x86-only
    ./../../modules/home/rofi/rofi.nix
    ./../../scripts/scripts.nix
    ./../../modules/home/ssh.nix
    # ./../../modules/home/spicetify.nix       # Spotify x86-only
    ./../../modules/home/superfile/superfile.nix
    ./../../modules/home/swaylock.nix
    ./../../modules/home/swayosd.nix
    ./../../modules/home/swaync/swaync.nix
    ./../../modules/home/vscodium
    ./../../modules/home/waybar
    ./../../modules/home/waypaper.nix
    ./../../modules/home/xdg-mimes.nix
    ./../../modules/home/zsh
  ];
}
