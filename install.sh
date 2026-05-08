#!/bin/bash
# Colors for output
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"
# ==========================================
# ARCH LINUX POST INSTALL SETUP SCRIPT
# ==========================================
# This script installs:
# 1. Development + Xorg environment (for DWM / X11)
# 2. Nerd fonts (for terminal + icons)
# 3. Virt-manager (KVM/QEMU virtual machines)
# 4. Bluetooth stack (Bluez + GUI tool)
# ==========================================

echo "Starting system setup..."

cat <<'EOF'


                                  WELCOME ON
 _____   ____  __  _    ___       _____ __ __  _____ ______    ___  ___ ___ 
|     | /    ||  |/ ]  /  _]     / ___/|  |  |/ ___/|      |  /  _]|   |   |
|   __||  o  ||  ' /  /  [_     (   \_ |  |  (   \_ |      | /  [_ | _   _ |
|  |_  |     ||    \ |    _]     \__  ||  ~  |\__  ||_|  |_||    _]|  \_/  |
|   _] |  _  ||     ||   [_      /  \ ||___, |/  \ |  |  |  |   [_ |   |   |
|  |   |  |  ||  .  ||     |     \    ||     |\    |  |  |  |     ||   |   |
|__|   |__|__||__|\_||_____|      \___||____/  \___|  |__|  |_____||___|___|


                            EVERYTHING IS AN ILLUSION 
EOF

# Get the current script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# SETTING UP YAY AND UPDATING THE PACKAGES
echo -e "${YELLOW}Setting up yay...${RESET}"
sudo pacman -Suy
sudo pacman -S --needed git base-devel go
git clone https://aur.archlinux.org/yay.git /tmp/yay-build
cd /tmp/yay-build
makepkg -si --noconfirm
cd "$SCRIPT_DIR"

# ------------------------------------------
# CLONE WALLPAPER REPO
# ------------------------------------------
echo -e "${YELLOW}Cloning wallpapers...${RESET}"
git clone https://github.com/NOTHING-R/Walllpapers.git ~/Walllpapers
echo "✔ Wallpapers cloned to ~/Walllpapers"

# ------------------------------------------
# CLONE TMUX PLUGIN MANAGER (tpm)
# ------------------------------------------
echo -e "${YELLOW}Cloning tmux plugin manager...${RESET}"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "✔ tpm cloned to ~/.tmux/plugins/tpm"

# INSTALLING ALL THE REQUERED PACKAGES
echo -e "${YELLOW}Installing required applications...${RESET}"

# ------------------------------------------
# 1. BASIC DEVELOPMENT + XORG ENVIRONMENT
# ------------------------------------------
# Installs essential build tools, X11 server, input drivers,
# and libraries required for window managers like DWM.

sudo pacman -S --needed --noconfirm \
  git \
  base-devel \
  xorg-server \
  xorg-xinit \
  xorg-xrdb \
  xorg-setxkbmap \
  libx11 \
  libxft \
  libxinerama \
  libinput \
  xf86-input-libinput \
  xorg-xinput \
  rofi \
  unzip \
  curl

echo "✔ Xorg + development tools installed"

# ------------------------------------------
# 2. FONTS (NERD FONTS + ICON SUPPORT)
# ------------------------------------------
# Installs modern monospace fonts with icon support
# useful for terminal, rofi, and coding environments.

sudo pacman -S --needed --noconfirm \
  noto-fonts-emoji \
  ttf-jetbrains-mono-nerd \
  ttf-firacode-nerd \
  ttf-hack-nerd \
  ttf-cascadia-code-nerd

# Refresh font cache so system detects new fonts
fc-cache -fv

echo "✔ Fonts installed and cache updated"

# ------------------------------------------
# 3. VIRTUALIZATION (Virt-Manager / KVM)
# ------------------------------------------
# Installs full QEMU/KVM virtualization stack
# for running virtual machines efficiently.

sudo pacman -S --needed --noconfirm \
  qemu-full \
  virt-manager \
  virt-viewer \
  dnsmasq \
  vde2 \
  openbsd-netcat \
  libvirt \
  edk2-ovmf

# Enable libvirt service (starts virtualization daemon)
sudo systemctl enable --now libvirtd

# Add current user to libvirt group (so no sudo needed later)
sudo usermod -aG libvirt "$(whoami)"

# Start default virtual network for VM internet access
sudo virsh net-start default
sudo virsh net-autostart default

echo "✔ Virt-manager + KVM setup complete"

# ------------------------------------------
# 4. BLUETOOTH SUPPORT
# ------------------------------------------
# Installs Bluetooth stack + GUI manager (Blueman)

sudo pacman -S --needed --noconfirm \
  bluez \
  bluez-utils \
  blueman

# Enable Bluetooth service at boot
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "✔ Bluetooth service enabled"

# ------------------------------------------
# 5. AUDIO (PipeWire + PulseAudio compat)
# ------------------------------------------
# PipeWire is the modern audio server. pipewire-pulse makes
# pactl and pavucontrol work as if PulseAudio is running.
# wireplumber is the session manager (required).
# pavucontrol gives you a GUI mixer.

sudo pacman -S --needed --noconfirm \
  pipewire \
  pipewire-pulse \
  pipewire-alsa \
  wireplumber \
  pavucontrol

# Enable PipeWire for the current user — will start automatically on first login
systemctl --user enable pipewire pipewire-pulse wireplumber

echo "✔ Audio stack installed (PipeWire + PulseAudio compat)"

# ------------------------------------------
# 6. WINDOW MANAGER / RICE CORE
# ------------------------------------------
# This installs essential tools for customizing a minimal Linux desktop:
# - picom: adds transparency, shadows, and blur effects
# - feh: sets wallpapers on X11 systems
# - dunst: lightweight notification daemon
# - libnotify: allows applications to send desktop notifications
# - network-manager-applet: nm-applet systray icon (used in .xinitrc)
# - brightnessctl: backlight control (used in dwm keybinds)
# - nsxiv: image viewer used by the wallpaper picker script

sudo pacman -S --needed --noconfirm \
  picom \
  feh \
  dunst \
  flameshot \
  libnotify \
  network-manager-applet \
  brightnessctl \
  nsxiv

# Set initial wallpaper from cloned repo so ~/.fehbg is created for later scripts
feh --bg-scale "$HOME/Walllpapers/crime.jpg"
echo "✔ Window manager rice core tools installed"
# ------------------------------------------
# 7. PROGRAMMING + TERMINAL TOOLCHAIN
# ------------------------------------------
# This installs tools for:
# - software development (C/C++/JS)
# - modern terminal workflow
# - fast CLI productivity tools

sudo pacman -S --needed --noconfirm \
  vim \
  neovim \
  gcc \
  clang \
  make \
  cmake \
  nodejs \
  npm \
  kitty \
  fish \
  stow \
  ripgrep \
  fd \
  curl \
  unzip \
  xclip \
  tmux \
  firefox

echo "✔ Programming + terminal toolchain installed"

# Set fish as the default shell
echo -e "${YELLOW}Setting fish as default shell...${RESET}"
chsh -s "$(which fish)"
echo "✔ Default shell set to fish"

# Sync everything before AUR installs
yay -Suy --noconfirm

echo -e "${YELLOW}Installing AUR packages (betterlockscreen, wlogout)...${RESET}"
yay -S --noconfirm betterlockscreen wlogout
# ------------------------------------------
# DOTFILES DEPLOY SCRIPT (DWM SETUP)
# ------------------------------------------
# This script copies configs from repo to:
# - ~/.config (all app configs)
# - ~/ (startup scripts / xinit files etc.)
# ------------------------------------------

echo "🚀 Starting dotfiles deployment..."

# Repo root — always use SCRIPT_DIR so we don't depend on cwd
REPO_DIR="$SCRIPT_DIR"

# ------------------------------------------
# 1. CONFIGS → ~/.config
# ------------------------------------------
echo "📦 Copying configs to ~/.config ..."

mkdir -p ~/.config

cp -rf "$REPO_DIR/configs/dunst" ~/.config/
cp -rf "$REPO_DIR/configs/kitty" ~/.config/
cp -rf "$REPO_DIR/configs/nvim" ~/.config/
cp -rf "$REPO_DIR/configs/picom" ~/.config/
cp -rf "$REPO_DIR/configs/wlogout" ~/.config/

echo "✔ Configs copied"

# ------------------------------------------
# 2. DEPLOY DWM + DWMBLOCKS → ~/.config
# ------------------------------------------
echo "📦 Copying dwm and dwmblocks to ~/.config ..."

cp -rf "$REPO_DIR/dwm" ~/.config/dwm
cp -rf "$REPO_DIR/dwmblocks" ~/.config/dwmblocks

# Make scripts executable
chmod +x ~/.config/dwm/scripts/*

echo "✔ dwm and dwmblocks copied to ~/.config"

# ------------------------------------------
# 3. BUILD + INSTALL DWM
# ------------------------------------------
echo -e "${YELLOW}Building and installing dwm...${RESET}"
cd ~/.config/dwm
make clean
make
sudo make install
cd "$SCRIPT_DIR"
echo "✔ dwm installed"

# ------------------------------------------
# 4. BUILD + INSTALL DWMBLOCKS
# ------------------------------------------
echo -e "${YELLOW}Building and installing dwmblocks...${RESET}"
cd ~/.config/dwmblocks
make clean
make
sudo make install
cd "$SCRIPT_DIR"
echo "✔ dwmblocks installed"

# ------------------------------------------
# 5. STARTUP FILES → HOME DIRECTORY
# ------------------------------------------
echo "🏠 Copying startup files to home..."

cp -f "$REPO_DIR/startup/.xinitrc" ~/
cp -f "$REPO_DIR/startup/.xprofile" ~/
cp -f "$REPO_DIR/startup/.Xresources" ~/
cp -f "$REPO_DIR/configs/.tmux.conf" ~/

echo "✔ .xinitrc, .xprofile, .Xresources, .tmux.conf → ~/"
