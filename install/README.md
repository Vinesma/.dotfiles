# How to use these scripts

These folders contain scripts to basically auto install my stuff, however some things do require manual intervention. I will try to outline them in this guide.

## Architect

- Get the [architect.](https://manjaro.org/download/)

- Shove it into a pen drive using Rufus or this (destructive, be careful) command: `sudo dd bs=4M if=[/path/to/iso] of=/dev/sd[x] status=progress` (check partitions with `sudo fdisk -l`)

- Use that to boot.

- [Follow the steps](https://wiki.manjaro.org/index.php?title=Installation_with_Manjaro_Architect) and get a CLI system up and running.

Recommendations:

- Set the virtual console key map to `br-abnt2` if you're Brazilian like me.

When the architect is done, chroot into the system and install `networkmanager`. Enable it with `systemctl enable NetworkManager` then reboot into the bare CLI system.

## Bare CLI

These steps should be taken after a reboot.

Find a connection:

- List: `nmcli device wifi list`

- List (UUIDs): `nmcli connection show`

- Connect: `nmcli device wifi connect SSID password PASS`

- Show devices: `nmcli device`

[More examples here](https://wiki.archlinux.org/index.php/NetworkManager#nmcli_examples)

Install `git` so you can clone this repo. Once you have git and are connected the scripts can do most of the heavy lifting for you. Go ahead and run `main.sh` to install all the things provided.

## Anything missing?

Try running the included python script `main.py` and selecting the "individual install" option.

- [cron won't be running by default, it needs to be enabled.](https://wiki.archlinux.org/index.php/Cron#Activation_and_autostart)

## Laptop considerations

If installing on a laptop a few more things require attention, such as [ACPI Events](https://wiki.archlinux.org/index.php/Power_management#Power_management_with_systemd) and [the touchpad.](https://wiki.archlinux.org/index.php/Libinput#Installation)

[Power saving](https://wiki.archlinux.org/index.php/Power_management#Power_saving) is also a thing I've yet to dive deep into.

## Dev stuff

### NeoVim

[neovim's](https://neovim.io/) huge ecosystem of settings and plugins is a lot to deal with.

- Run `:checkhealth` for a overview of what is supported, like python support and others.

Plugins:

- Install [vim-plug](https://github.com/junegunn/vim-plug/wiki/tutorial#setting-up)

- [Declare the plugins to be used inside the init.vim file.](https://github.com/junegunn/vim-plug/wiki/tutorial#installing-plugins)

- Restart nvim. Now run `:PlugInstall` to install the plugins.

- To upgrade plugins, run `:PlugUpdate`.

- Remove plugins by removing their lines in the config file, restarting nvim and then running `:PlugClean`.

CoC : Code completion:

Run this command inside neovim (after CoC is installed) to install all my code completion extensions:

`CocInstall coc-css coc-emmet coc-html coc-json coc-python coc-sh coc-tsserver coc-pairs`

### Arch User Repository (AUR)

[How to use the AUR.](https://wiki.archlinux.org/index.php/Arch_User_Repository#Getting_started)

### Setting up Android Studio

- [Install Android Studio from the AUR](https://aur.archlinux.org/packages/android-studio)

- For device emulation, [enable virtualization in the BIOS](https://support.bluestacks.com/hc/en-us/articles/115003174386-How-can-I-enable-virtualization-VT-on-my-PC-) and check [this KVM article.](https://wiki.archlinux.org/index.php/KVM)

### Setting up Flutter

- Clone the flutter repo somewhere appropriate: `git clone https://github.com/flutter/flutter.git`

- Add the line `export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"` to `.bashrc`

- Run `flutter doctor` to verify missing dependencies

- Install the VSCode Flutter extension

## Problems encountered:

### A script run via cron fails to send notifications via notify-send.

[Solution: cron has no access to the DBUS address and the DISPLAY variable, they have to be set inside your script or before the notify-send call.](https://wiki.archlinux.org/index.php/Cron#Running_X.org_server-based_applications)

### The system clock is wrong.

[Solution](https://wiki.archlinux.org/index.php/System_time#Read_clock) (run `timedatectl` to check, can also be used to set time)

Run this to enable clock synchronization:

- `timedatectl set-ntp true`

### Laptop only boots or runs when charging, as soon as it gets unplugged the laptop freezes half a second later.

Solution: Disabling tlp in `/etc/tlp.conf` by editing the line TLP_ENABLE=1 to TLP_ENABLE=0. Afterwards, edit `/etc/default/cpupower` and set `governor` to "performance". This fixes the problem but leaves the laptop without any power saving capability. I will update this with more info as I investigate the issue.

[TLP debugging](https://linrunner.de/tlp/support/troubleshooting.html#step-3-disable-tlp-temporarily)

### Laptop won't shutdown or reboot completely. Screen goes black but external lights stay on and the fan keeps spinning no matter how long I wait.

Solution: None, yet.

### pywal has no support for dunst

Solution: For pywal to work with dunst, copy the template file in `dunst/colors-dunst` to `~/.config/wal/templates/`. Edit the template accordingly and then run `wal-scale` with a path to your desired wallpaper in a terminal. I have provided scripts to help with this.

This also applies to anything else unsupported by pywal.

### The Kernel can't be loaded

Solution: I once fixed this by booting with a pen drive on liveCD, opening a terminal, running `manjaro-chroot -a` and then running `grub-mkconfig`.

## Links/Resources

Things that had their own section and were moved or removed, along with other resources that don't fit anywhere else:

- Info on [manjaro-printer.](https://wiki.manjaro.org/index.php?title=Printing#Overview)
