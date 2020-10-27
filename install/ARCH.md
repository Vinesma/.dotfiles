(27/10/2020)

Taken from the excellently written [bossley9 dotfiles repo](https://github.com/bossley9/dotfiles/blob/master/README.md)

I may use this if I ever install Arch, I think it's much easier to follow that the wiki.

#### Setup <a name="setup"></a>

1. For this guide you will need the following tools:
    - A computer that will be wiped to install a new OS
    - An internet connection (preferably ethernet)
    - A disposable usb drive that can be wiped
2. Download the latest [Archlinux](https://www.archlinux.org/download/) installation iso from
    their website. I downloaded version `archlinux-2020.09.01-x86_64.iso`.
3. Burn the downloaded cd image onto the usb.
    This can be done using a number of different tools:
    - [Balena Etcher](https://www.balena.io/etcher/)
    - [Rufus](https://rufus.ie/)
    - [Mkusb](https://help.ubuntu.com/community/mkusb)
    - Or, if you prefer command line like me:
      ```
      sudo dd bs=4M if=/path/to/iso of=/dev/sdx status=progress
      ```
      where `/dev/sdx` is the root partition of the usb (do not include specific partition
      numbers). You may want to run `sudo fdisk -l` first to double check the partition name.
4. Boot the machine from the live usb (you may need to modify BIOS settings to boot from a
    usb hard drive). If you don't know how to do this, look up how to boot from a live usb
    and how to change the bios settings for your machine.

Booting from the usb will open a menu. Choose to boot from the live usb.
After loading screens you will eventually land on a simple command prompt.

#### Preliminary Internet <a name="preliminternet"></a>

1. After verifying the ethernet cable is plugged in (if applicable), test the internet by
    typing the following command:
    ```
    ping archlinux.org
    ```
    If an internet connection has already been established, you will see an incremental
    output displaying packet information. If internet has not yet been set
    up on the machine, it will likely provide the following error:
    ```
    ping: archlinux.org: Name or service not known
    ```
    If a response appears, type `ctrl-c` to stop the ping and skip ahead to the next section.
2. If you arrived at this step, we'll assume no internet is connected.
    We'll need to get the names of all network cards with
    `ip link`. Remember the names of the cards that display. On most machines there are only
    three network cards:
    - `lo` represents a loopback device, which is kind of like a virtual network (this is how
        we access `127.0.0.1` and other localhost ports).
    - `eth0` represents an ethernet adapter. Usually the interface is given a more specific
        name, such as `enp34s0`. In this guide I will use `eth0` to represent the ethernet
        card name.
    - If your machine has a wifi card, it will be represented by `wlan0`. As with the
        ethernet card, this is usually passes under a more specific name, like `wlp1s0`.
        In this guide I will use `wlan0` to represent the wireless card name.
3. We will now establish an internet connection to download all necessary packages.
    It is definitely possible to install the OS on the machine using only wifi (using a utility
    such as [`iwctl`](https://wiki.archlinux.org/index.php/Iwd#iwctl)), but I recommend
    against wifi if possible since it involves a lot more complication and will be subsequently
    slower during the install process.

    **To install with ethernet:**
    1. Copy the netctl example ethernet configuration.
        ```
        cp /etc/netctl/examples/ethernet-static /etc/netctl
        ```
    2. `vim /etc/netctl/ethernet-static` to change the interface to the interface found earlier.
        ```
        Interface=eth0
        ```
    3. Enable the configuration and reboot.
        ```
        netctl enable ethernet-static
        systemctl stop dhcpcd
        systemctl disable dhcpcd
        sudo reboot
        ```
    4. Verify `ping archlinux.org` produces a response. Do not proceed and repeat this section
        until a response appears.

    **To install with wifi:**
    1. Enter the `iwctl` prompt by typing `iwctl` in the command line.
    2. Verify the computer's wifi card with `device list`. This should display the wifi
    card(s) you saw earlier with `ip link`.
    3. Scan for networks using `station wlan0 scan`, where `wlan0` is the network card name.
        This command will not display any output and instead silently scan.
    4. List all scanned networks with `station wlan0 get-networks`.
    5. Connect to the internet network with `station wlan0 connect SSID`. This will prompt
        a password if required. Then type `exit` to return to the original prompt.
    6. Verify `ping archlinux.org` produces a response. Do not proceed and repeat this section
        until a response appears.

#### System Time <a name="systime"></a>
1. Update the system time.
    ```
    timedatectl set-ntp true
    ```

#### Disk Partitioning <a name="diskpartition"></a>
We will be creating a main partition for all files and a swap partition for suspending and
hibernation. To view the GB amount of memory installed in the system, run the `free -g`
command. To be safe, we will make the swap partition to be twice the amount of total RAM.

1. To view the disks to partition, use `fdisk -l` to display all drives and note the drive you wish to install Arch on. Make sure this drive is not the usb drive. Mine is `/dev/sda`, and as such, I will be using this drive for the purposes of this guide. Run the following command to open the partitioning editor for that disk:
    ```
    fdisk /dev/sda
    ```
    You can list any existing partitions in this prompt using `p`.
2. Delete all existing partitions on this drive by typing `d` consecutively and selecting
    existing partitions until it states that no partitions are defined.
3. Type `p` to display the disk size.
3. Type `n` to create a new partition, and `p` to make this a primary partition. Partition
    number and first sector can both be left at default. You can press `ENTER` to use the
    default for both of these prompts.
4. This partition will be the swap partition, which will be twice the size of RAM. My system
    uses 16Gb of RAM, so the partition created will be 2 x 16Gb = 32Gb.
    ```
    +32G
    ```
    Press `ENTER` again to allocate the entire disk for the partition, and `y` to remove any
    existing signatures.
5. The rest of the space will be used for the main partition. Using the same commands, create
    a partition which uses the rest of the disk. When prompted for the last sector, type
    `ENTER` to use the rest of the space, and remove any existing signatures.
6. Type `w` to write the changes to the hard drive (this is permanent). You will be able to
    use `fdisk -l` to view the changes to the disk.
7. Change the partition extensions. In my case, my swap partition is `/dev/sda1` and my root
    partition is `/dev/sda2`.
    ```
    mkfs.ext4 /dev/sda2
    mkswap /dev/sda1
    swapon /dev/sda1
    ```
8. Mount the created root file partition.
    ```
    mount /dev/sda2 /mnt
    ```

#### Distro Installation <a name="distroinstall"></a>
1. Install the linux kernel and base. This will take some time to complete. I also
    recommended installing `base-devel` development tools and an editor like `vim`.
    ```
    pacstrap /mnt base base-devel linux linux-firmware neovim
    ```

#### Mounting with Fstab <a name="fstabmount"></a>
`fstab` is used to mount drives to the system.

1. Generate an `fstab` file.
    ```
    genfstab -U /mnt >> /mnt/etc/fstab
    ```
2. Then log into the system. This should change your prompt.
    ```
    arch-chroot /mnt
    ```

#### System Network Manager <a name="networkmanager"></a>
1. Install `networkmanager`.
    ```
    pacman -S networkmanager
    ```
2. Enable `networkmanager` on boot.
    ```
    systemctl enable NetworkManager
    ```

#### Grub Bootloader <a name="grubboot"></a>
1. Install `grub`.
    ```
    pacman -S grub
    grub-install --target=i386-pc /dev/sda
    ```
2. Generate the `grub` configuration.
    ```
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

#### Password <a name="password"></a>
1. Set a password for the root user.
    ```
    passwd
    ```

#### Locales and System Information <a name="locales"></a>
1. `nvim /etc/locale.gen` to enable locales. I speak and use English as my system language,
    but yours might be different. Adjust accordingly.
    ```
    en_US.UTF-8 UTF-8
    ```
2. Then generate locales.
    ```
    locale-gen
    ```
3. `nvim /etc/locale.conf` to set the system language.
    ```
    LANG=en_US.UTF-8
    ```
4. Synchronize the local time and hardware clock, where [region] is your region and [city]
    is your city:
    ```
    ln -sf /usr/share/zoneinfo/[region]/[city] /etc/localtime
    hwclock --systohc
    ```
5. `nvim /etc/hostname` to name the machine. I named mine `diobrando`.
    ```
    diobrando
    ```
6. Then `nvim /etc/hosts` to update the host list accordingly:
    ```
    127.0.0.1   localhost
    ::1         localhost
    127.0.1.1   diobrando.localdomain   diobrando
    ```

#### Installation Wrapup <a name="installwrap"></a>
1. Exit, unmount the filesystem, and shutdown. Safely remove the usb after the machine is
    powered off.
    ```
    exit
    umount -R /mnt
    shutdown -h now
    ```
2. Power on the machine. It should boot immediately into a login prompt. Then log in as the
    root user using `root` as your username and the password you set earlier.
    If it does not display a login prompt, the OS was not set up correctly.
    Repeat the previous steps to install the OS.

#### Wifi <a name="wifi"></a>
1. A wifi network connection can be set up from the command line temporarily if needed. Run
    `nmcli d wifi list` to display all networks. Then connect with the appropriate SSID and
    password.
    ```
    nmcli d wifi connect SSID password PASSWORD
    ```
    The current network status can be displayed with the `nmcli radio` and `nmcli device`
    commands.

    More complicated networks may require more settings, and `nmtui` provides a more
    comfortable user-interface for complex networks such as school networks, vpns, or hotel
    networks.

#### Creating a User <a name="creatinguser"></a>
1. Create a user. This is the user you will use to log in. I will create a user named `sam`.
    ```
    useradd -m -g wheel sam
    passwd sam
    ```
2. `EDITOR=nvim visudo` to grant the new user sudo permissions.
    ```
    %wheel ALL=(ALL) ALL
    ```
3. Log out and log back in as the user.
    ```
    exit
    ```

#### Core Packages <a name="corepackages"></a>
1. Install a system upgrade. It's good to do this on a clean install. Additionally, install
    useful package helpers like `git` and `yay`.
    ```
    sudo pacman -Syyuu
    sudo pacman -S git

    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si
    ```
2. Install `zsh` and set it as the default shell for the main user.
    ```
    sudo pacman -S zsh
    chsh -s /bin/zsh
    ```
3. Install `X` server packages.
    ```
    sudo pacman -S xorg-xinit xorg-server
    ```
    My dotfiles will automatically use `st` as the default terminal emulator.
    If you choose to not use `st` as a terminal emulator, make sure you install at
    least one terminal emulator and change the `TERM` environment variable located in
    `.profile` and update the binding in `sxhkdrc`. If you do not have a terminal emulator
    installed and properly setup, my dotfiles will not work.
5. Log out and log back in.
    ```
    exit
    ```
    If prompted to create a `zsh` startup file, you can press `q` to quit and do nothing. My
    dotfiles contain necessary `zsh` startup files. You can then remove old `bash` files.
    ```
    rm .bash*
    ```
6. Finally, install my dotfiles. See [cloning](#cloning) for more details.

## Additional Configuration or Notes <a name="addconfig"></a>
This list of additional configuration options are in no particular order. I've just added or
modified them when necessary.

- [Touchpad Settings](#touchpad-settings)
- [Disabling the Grub Menu](#disabling-grub-menu)
- [DaVinci Resolve](#davinci-resolve)
- [Gaming](#gaming)
- [Login](#login)
- [No dwm?](#no-dwm)
- [Glasscord](#glasscord)
- [User Custom CSS](#user-custom-css)

#### Touchpad settings <a name="touchpad-settings"></a>
By default, most linux distros disable natural scrolling and disable touchpad tapping. I
personally find this very irritating. To change touchpad settings,
`sudo nvim /etc/X11/xorg.conf.d/30-touchpad.conf` and add the following configuration:
```
Section "InputClass"
	Identifier "touchpad"
	Driver "libinput"
	MatchIsTouchpad "on"
	Option "Tapping" "on"
	Option "NaturalScrolling" "true"
EndSection
```
Then reboot to verify changes.

#### Disabling the Grub Menu <a name="disabling-grub-menu"></a>
If, like me, you don't plan on dual-booting or adding boot entries, you can disable the grub
selection menu with `sudo nvim /etc/default/grub`:
```
GRUB_TIMEOUT=0
```
Update the grub, then reboot.
```
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

#### DaVinci Resolve <a name="davinci-resolve"></a>
`DaVinci Resolve` can be quite cumbersome to get working on a Linux system, especially for one
using an AMD gpu. These are the steps I took to install it on my machine, being very
particular on drivers.
```
sudo pacman -S xf86-video-amdgpu vulkan-radeon libva-mesa-driver
yay -S amdgpu-pro-libgl opencl-amd
sudo reboot
--------------------------------------------
yay -S davinci-resolve
```
It's also important that the free version that comes with Linux does not have `mp3/4` or
`h.264` support.
I have a simple shell function written in `.config/aliasrc` which converts to the right
codecs.

#### Gaming <a name="gaming"></a>
With these settings, I have been able to play every game I've tried.
> I use the following hardware components:
> - CPU: AMD Ryzen 9 3900x
> - GPU: AMD Radeon RX 580
>
> I specifically chose AMD products for my build since all Nvidia
> drivers are proprietary and I strongly advocate for open source
> software. Sorry, no RTX. But I think it's best in the long run.

A lot of gaming applications (such as the Steam client and Wine client) are 32-bit
architecture and require the `multilib` repository to be enabled. To enable,
`sudo nvim /etc/pacman.conf` and uncomment the following section:
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```
Then upgrade the system.
```
sudo pacman -Syu
```
You will also need to install the following packages. Many of these are essential for running
games of any kind.
```
sudo pacman -S wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
```
[Lutris also recommended that I install drivers specific to my GPU](https://github.com/lutris/docs/blob/master/InstallingDrivers.md).

#### Login <a name="login"></a>

The default login prompt is generic and simple. If you would like to modify it, you can use
different X-run interfaces to beautify the login prompt. I aim for minimalism, and think that
any X server running for the purposes of an aesthetic login prompt is unnecessary bloat. As
an alternative, you can edit the `/etc/issue` file to modify what is displayed on the login
prompt. In my setup, I use `figlet` to create a fancy hostname title on the login prompt.
```
cat /etc/hostname | figlet -k | { sed 's/\\/\\\\/g'; echo "(\l) \\s \\\r \\\t\n" } | sudo tee /etc/issue > /dev/null
```
You'll have to log out and log back in to notice changes.

#### No dwm? <a name="no-dwm"></a>
It might be surprising that I am such an advocate for suckless utilities and yet do not use
`dwm`, and to that statement I have a few reasons.

Conceptually, `dwm` is fantastic, and more tiling window managers should be formatted using
tags.

However, a large deal-breaker for me is that `dwm` integrates mostly with status bars such as
`slstatus` or `i3blocks`. I have grown more than comfortable with `polybar`, its capabilities,
and modularity, and until a
[`dwm` module is built into `polybar`](https://github.com/polybar/polybar/pull/2151), I have
less reason to use it. Additionally, I have grown accustomed to managing key bindings in
`sxhkd`. While other suckless utilities use application-specific key bindings, I prefer
maintaining window manager key bindings from within `sxhkd`.

That being said, I've given this a lot of thought recently, and I may revisit `dwm` in the
future. As such, I am leaving my module build of `dwm` included in my dotfiles should I
ever switch to `dwm` down the road.

#### Glasscord <a name="glasscord"></a>
I prefer using `ibhagwan`'s [picom blur and rounded corners fork](https://github.com/ibhagwan/picom)
for as many applications as possible, and as such, I use [Glasscord](https://github.com/AryToNeX/Glasscord)
because it allows modification of all Electron-based applications to follow this pattern.
Each installation is very similar, following [these steps](https://github.com/AryToNeX/Glasscord#how-do-i-install-it).

Here are the paths to apps I have already modified with Glasscord:

- Discord - `/opt/discord`

#### User Custom CSS <a name="user-custom-css"></a>
Firefox and a few other browsers offer support for custom user stylesheets which override the
default styles. This is mainly intended for accessibility purposes, but it can also be used
to customize the appearance of the browser.

To enable custom stylesheets on Firefox:
- open `about:config` in the address bar and set the following properties to `true`:
    - `gfx.webrender.all`
    - `toolkit.legacyUserProfileCustomizations.stylesheets`
- open your profile folder by opening `about:support` in the address bar and opening the
    folder next to the profile directory. I prefer keeping all configuration files in the
    `$XDG_CONFIG_HOME` or `~/.config` directory, so my configuration is under
    `$XDG_CONFIG_HOME/mozilla/profile`.
- to link my configuration to the Firefox profile:
    ```
    ln -s $XDG_CONFIG_HOME/mozilla/profile/chrome $FIREFOX_PROFILE_DIR/chrome
    ```
- restart Firefox and open `about:support` and verify that the `graphics` > `compositing` option has changed from `basic` to `opengl`. Styles and transparency effects should now be enabled.
