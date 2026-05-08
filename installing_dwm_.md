# A important note

to login in tty of arch you have to use on my laptop `fn+ctrl+alt+f3`

# Required Tools

```bash
sudo pacman -S git base-devel xorg-server xorg-xinit libx11 libxft libxinerama libinput xf86-input-libinput xorg-xinput

```

# fonts

```bash
sudo pacman -S noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-hack-nerd ttf-cascadia-code-nerd
fc-cache -fv
```

# Installing dwm and dwmblocks

```bash
git clone https://github.com/torrinfail/dwmblocks.git
git clone https://git.suckless.org/dwm
cd dwm
sudo make clean install
```

# Important patchs

## awesomebar

```bash
wget https://dwm.suckless.org/patches/awesomebar/dwm-awesomebar-20250923-6.6.diff
```

# Virt Manager

```bash
sudo pacman -S --needed \
    qemu-full \
    virt-manager \
    virt-viewer \
    dnsmasq \
    vde2 \
    openbsd-netcat \
    libvirt \
    edk2-ovmf

sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt "$(whoami)"
sudo virsh net-start default
sudo virsh net-autostart default

```

# bluetooths

```bash
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
```
