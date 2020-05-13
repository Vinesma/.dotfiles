# How to use these scripts

These folders contain scripts to basically auto install my stuff, however some things do require manual intervention. I will try to outline them in this guide.

## Architect

First of all, get the [architect](https://manjaro.org/download/) and run it. Follow the steps and get a CLI system up and running.

Recommendations:

- Set the virtual console keymap to `br-abnt2`.

When the architect is done, chroot into the system and install `networkmanager`. Enable it with `systemctl enable NetworkManager` then reboot into the bare CLI system.

## Bare CLI

After the reboot you need to find a network to connect to with the `nmcli` interface. [Examples here](https://wiki.archlinux.org/index.php/NetworkManager#nmcli_examples), remember to also install `git` so you can clone this repo. Once you have git and are connected the scripts can do most of the heavy lifting for you. Go ahead and run main.sh to install and configure the important stuff.

## Basic WM running

Once here, you can install anything in `optionals/`, most of it will also automatically get added to `.xprofile` to autostart.

- [To setup the notification DBUS](https://wiki.archlinux.org/index.php/Desktop_notifications#Standalone)

- [If the system clock is wrong](https://wiki.archlinux.org/index.php/System_time#Read_clock) (run `timedatectl` to check, can also be used to set time)

- [To enable cron](https://wiki.archlinux.org/index.php/Cron#Activation_and_autostart)

## Laptop

If installing on a laptop a few more things require attention, such as [ACPI Events](https://wiki.archlinux.org/index.php/Power_management#Power_management_with_systemd) and [the touchpad.](https://wiki.archlinux.org/index.php/Libinput#Installation)

[Power saving](https://wiki.archlinux.org/index.php/Power_management#Power_saving) is also a thing I've yet to dive deep into.

## Problems encountered:

- cron fails to send notifications via notify-send.

[Untested solution](https://wiki.archlinux.org/index.php/Cron#Running_X.org_server-based_applications). Will try this later.

- Laptop only boots or runs when charging, as soon as it gets unplugged the laptop freezes half a second later.

Solution: Disabling tlp in `/etc/tlp.conf` by editing the line TLP_ENABLE=1 to TLP_ENABLE=0. Afterwards, edit `/etc/default/cpupower` and set `governor` to "performance". This fixes the problem but leaves the laptop without any powersaving capability. I will update this with more info as I investigate the issue.

- Laptop won't shutdown or reboot completely. Screen goes black but external lights stay on and the fan keeps spinning no matter how long I wait.

Solution: I've yet to find one. Investigating.
