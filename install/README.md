# How to use these scripts

These folders contain scripts to basically auto install my stuff, however some things do require manual intervention. I will try to outline them in this guide.

## Architect

First of all, get the [architect](https://manjaro.org/download/) and run it. Follow the steps and get a CLI system up and running.

Recommendations:

- Set the virtual console keymap to `br-abnt2`.

When the architect is done, chroot into the system and install `networkmanager`. Enable it with `systemctl enable NetworkManager` then reboot into the bare CLI system.

## Bare CLI

After the reboot you need to find a network to connect to with the `nmcli` interface. [Examples here](https://wiki.archlinux.org/index.php/NetworkManager#nmcli_examples), once you are connected the scripts can do most of the heavy lifting for you. Go ahead and run main.sh to install and configure the important stuff.

## Laptop

If installing on a laptop a few more things require attention, such as [ACPI Events]() and [the touchpad.](https://wiki.archlinux.org/index.php/Libinput#Installation)

[Power saving](https://wiki.archlinux.org/index.php/Power_management#Power_saving) is also a thing I've yet to dive deep into.
