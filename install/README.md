# How to use these scripts

These folders contain scripts to basically auto install my stuff, however some things do require manual intervention. I will try to outline them in this guide.

## Architect

- Get the [architect.](https://manjaro.org/download/)

- Shove it into a pen drive using Rufus or this (destructive, be careful) command: `sudo dd bs=4M if=[/path/to/iso] of=/dev/sd[x] status=progress` (check partitions with `sudo fdisk -l`)

- Use that to boot.

- [Follow the steps](https://wiki.manjaro.org/index.php?title=Installation_with_Manjaro_Architect) and get a CLI system up and running.

Recommendations:

- Set the virtual console key map to `br-abnt2` if you're Brazilian like me.

- For partitioning, I usually go with 80 gigs for `/`, whatever my RAM is for `[SWAP]` and then give the rest over to `/home`.

When the architect is done, chroot into the system and install `networkmanager`. Enable it with `systemctl enable NetworkManager` then reboot into the bare CLI system.

## Bare CLI

These steps should be taken after a reboot.

Find a connection:

- List: `nmcli device wifi list`

- List (UUIDs): `nmcli connection show`

- Connect: `nmcli device wifi connect SSID password PASS`

- Show devices: `nmcli device`

[More examples here](https://wiki.archlinux.org/index.php/NetworkManager#nmcli_examples)

Install `git` so you can clone this repo, you may also need to install `python`. Once you have both and are connected the scripts can do most of the heavy lifting for you. Go ahead and run `python main.py` to install all the things provided.

After everything is done, make sure to run `chmod +x ~/.autostart` so that qtile can run the autostart file. Then reboot the system.

## Anything missing?

Try running the included python script `main.py` and selecting the "individual install" option.

- [cron won't be running by default, it needs to be enabled.](https://wiki.archlinux.org/index.php/Cron#Activation_and_autostart)

## TLP

Provides power saving capabilities. More relevant if using a laptop.

To check the status of TLP run: `tlp-stat -s`

[More info](https://linrunner.de/tlp/installation/arch.html)

## Dev stuff

### NeoVim

[neovim](https://neovim.io/) is my editor of choice. Here's how to get the best from it.

- Run `:checkhealth` for a overview of what is supported, like python support and others.

Plugins:

- Install [vim-plug](https://github.com/junegunn/vim-plug/wiki/tutorial#setting-up)

- [Declare the plugins to be used inside the init.vim file.](https://github.com/junegunn/vim-plug/wiki/tutorial#installing-plugins)

- Restart nvim. Now run `:PlugInstall` to install the plugins.

- To upgrade plugins, run `:PlugUpdate`.

- Remove plugins by removing their lines in the config file, restarting nvim and then running `:PlugClean`.

VSCode integration:

- For using neovim inside vscode, you need to install a vscode extension.

- After it is installed, you will need neovim 0.5.0+ which is not in the repos. The easiest way to acquire it is by [downloading the appimage](https://github.com/neovim/neovim/releases) running: `chmod u+x` on it, then adding the path to it in the extension config.

### Arch User Repository (AUR)

I use `yay` as an AUR helper. It should be installed after running my scripts.

[How to use the AUR.](https://wiki.archlinux.org/index.php/Arch_User_Repository#Getting_started)

### Setting up VirtualBox

- Run the command: `$ LC_ALL=C lscpu | grep Virtualization` to check if Virtualization is supported. If nothing is shown then Virtualization is **not** supported

- [Enable virtualization in the BIOS](https://support.bluestacks.com/hc/en-us/articles/115003174386-How-can-I-enable-virtualization-VT-on-my-PC-)

- [Guide](https://wiki.manjaro.org/index.php/VirtualBox)

### Setting up Android Studio

- Android Studio can be installed via the AUR

- [Guide](https://wiki.archlinux.org/index.php/Android#Android_Studio)

- [React Native Guide](https://reactnative.dev/docs/environment-setup)

### Setting up Flutter

- Install flutter from the AUR

- Run `flutter doctor` to verify missing dependencies

- Install the VSCode Flutter extension

- [Guide](https://flutter.dev/docs/get-started/install)

### Setting up SSH

For ssh, we have to identify what machine you want to use as a `client` and which you want to use as a `server`. Most configuration will be done in the `server`.

`server`:

- Install `openssh` (It's probably already installed)

- Enable the server: `systemctl enable --now sshd.service`

`client`:

- Create a key pair using `ssh-keygen`

- Copy the newly generated pair to the server using `ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@$IP_ADDR`. $USER = The username to log in at the server, $ADDR = The server ip which can be found by running `ip a` at the server

- Connect to the server using `ssh $USER@$ADDR`

`server`:

- Configure `/etc/ssh/sshd_config`, important settings to change are `Port`, changing `PermitRootLogin` to `no` and adding `PasswordAuthentication no` to force key based authentication. This can be done remotely. Don't forget to restart the server afterwards using `systemctl restart sshd.service`

`client`:

- Configure `~/.ssh/config` using the examples located at `~/.dotfiles/files/ssh_config`. This enables faster connection to the server by simply typing `ssh $HOST` instead of `ssh -p $PORT $USER@IP_ADDR`

Tips:

The keys can be named however you want for ease of identification. You can also pass the `-t` flag to the `ssh-keygen` command to use different cryptographic algorithms, such as 'ed25519'

A `ssh-agent` user file is included in the install, this will cache ssh passwords so that no massive amounts of password typing is needed. To use it, enable the service with `systemctl enable --user --now ssh-agent.service` and add your private keys with `ssh-add ~/.ssh/KEY_NAME`. To make all ssh clients store keys in the agent on first use, add the configuration setting `AddKeysToAgent yes` to `~/.ssh/config`.

## Problems encountered:

### A script run via cron fails to send notifications via notify-send.

[Solution: cron has no access to the DBUS address and the DISPLAY variable, they have to be set inside your script or before the notify-send call.](https://wiki.archlinux.org/index.php/Cron#Running_X.org_server-based_applications)

### The system clock is wrong.

[Solution](https://wiki.archlinux.org/index.php/System_time#Read_clock) (run `timedatectl` to check, can also be used to set time)

Run this to enable clock synchronization:

- `timedatectl set-ntp true`

### pywal has no support for dunst

Solution: For pywal to work with dunst, copy the template file in `~/.dotfiles/pywal-templates/colors-dunst` to `~/.config/wal/templates/`. Edit the template accordingly and then run `wal` with a path to your desired wallpaper in a terminal. The template will be parsed and spit out at `~/.cache/wal/colors-dunst` which can then be linked to `~/.config/dunst/dunstrc`. You will only need to do this if something goes horribly wrong, since my install scripts should be able to take care of it.

This also applies to anything else unsupported by pywal.

### Laptop only boots or runs when charging, as soon as it gets unplugged the laptop freezes half a second later.

Solution: Disabling tlp in `/etc/tlp.conf` by editing the line TLP_ENABLE=1 to TLP_ENABLE=0. Afterwards, edit `/etc/default/cpupower` and set `governor` to "performance". This fixes the problem but leaves the laptop without any power saving capability.

[TLP debugging](https://linrunner.de/tlp/support/troubleshooting.html#step-3-disable-tlp-temporarily)

### Laptop won't shutdown or reboot completely. Screen goes black but external lights stay on and the fan keeps spinning no matter how long I wait.

Solution: Never found a solution, but reinstalling the system a few months later kicked the issue to the curb.

### The Kernel can't be loaded

Solution: I once fixed this by booting with a pen drive on liveCD, opening a terminal, running `manjaro-chroot -a` and then running `grub-mkconfig`. I bet reinstalling grub could fix it too.

### Wrong resolution upon startup

Solution: Add `xrandr --output OUTPUT --mode WIDTHxHEIGHT` to the line that starts with `greeter-setup-script` in `/etc/lightdm/lightdm.conf`. You can find the values needed by running `xrandr` with no arguments. In my experience, the resolution is correct about 30% of the time when I boot.

The only real solution I've found is to immediately shutdown your WM and login again. This works but is quite annoying.

### Something else went *kaput*

Solution: I hope you had timeshift configured because it'll be the thing to save you. Find a pen drive with a liveCD to boot with, install timeshift on the live environment and let it restore from your timeshift snapshot directory (usually `/run/timeshift/backup/timeshift/snapshots/`).

## Links/Resources

Things that had their own section and were moved or removed, along with other resources that don't fit anywhere else:

- [manjaro-printer.](https://wiki.manjaro.org/index.php?title=Printing#Overview)
- [Touchpad.](https://wiki.archlinux.org/index.php/Libinput#Installation)
- [ACPI Events](https://wiki.archlinux.org/index.php/Power_management#Power_management_with_systemd)
- [Power saving](https://wiki.archlinux.org/index.php/Power_management#Power_saving)
