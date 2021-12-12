(08/12/2021) Forked from the excellently written [bossley9's Arch install instructions](https://github.com/bossley9/Dotfiles/tree/arch) with my own modifications and additions.

Meant as a companion guide to the [official Arch guide.](https://wiki.archlinux.org/title/Installation_guide) Some things are only covered there, while this gets you up to speed faster.

## Install instructions

## Setup <a name="setup"></a>

- Download the latest [Archlinux image](https://archlinux.org/download) from the website.
  Given the option, I downloaded version `2021.07.01-x86_64`.
  I would highly recommend using checksums to validate the integrity of the image.
- Burn the downloaded disk image onto the usb.
  This can be done using a number of different tools:
  - [Balena Etcher](https://www.balena.io/etcher) (cross-platform)
  - [Rufus](https://rufus.ie) (Windows)
  - [Mkusb](https://help.ubuntu.com/community/mkusb) (Linux/Ubuntu)
  - If you prefer command line like me (where $ denotes elevated privileges):
    ```
    $ dd bs=4M if=/path/to/img of=/dev/sdx status=progress
    ```
- Boot the computer from the live usb.
  This may require manual BIOS tweaking depending on your machine.
  Be sure to boot with UEFI (especially if you plan on dual booting with Windows).

## Boot Start <a name="boot-start"></a>

The boot process should eventually land on a virtual terminal prompt where you can log in with the given credentials.

- Use `loadkeys [layout]` to load a keyboard layout. Mine is `br-abnt2`.
- Verify the boot mode is UEFI via `ls /sys/firmware/efi/efivars`. If nothing is returned the boot mode might not be UEFI.

## Internet <a name="internet"></a>

- You can test for internet with the following command:
  ```
  ping archlinux.org
  ```
  If an internet connection has already been established, you will see an incremental
  output of packets.
  If not, a DNS error will return.
  ```
  ping: archlinux.org: Name or service not known.
  ```
  Type `ctrl+c` to stop the program.
  If an internet connection has been established, you can skip ahead to the next step.
- Assuming no internet connection exists, use `ip link` to retrieve the names of all network cards.
  Remember the names of the cards that display.
  On most machines there are at least three types of network cards:
  - `lo` represents a loopback device, which is similar to a virtual network.
    This is how 127.0.0.1 and other localhost ports are accessed.
  - `eth0` represents an ethernet (wired) network card.
    Usually the interface is given a more specific name, such as `enp34s0`.
  - `wlan0` represents a wireless network card.
    As with ethernet, this usually passes under a specific name like `wlp1s0`.
    In this guide I use wlan0 to represent the wireless card name.
- If you plan on using ethernet, internet should automatically be configured.
  Otherwise, you can connect to a network with iwd:
  - Enter the iwctl prompt.
    ```
    iwctl
    ```
  - Verify the computer's wireless card.
    This should display the wireless card(s) you saw earlier with ip link.
    ```
    device list
    ```
  - Scan for local networks.
    This command does not display any output and instead silently scans.
    ```
    station wlan0 scan
    ```
  - List all scanned networks.
    ```
    station wlan0 get-networks
    ```
  - Connect to an internet network, where SSID is the name of the network.
    This will prompt for a password if required.
    ```
    station wlan0 connect SSID
    ```
  - Type `exit` to return to the original terminal prompt.
  - Verify `ping archlinux.org` produces a response.
    Do not proceed and repeat this section until a response appears.

## Update the System Clock <a name="update-the-system-clock"></a>

- Update the system clock.
  ```
  timedatectl set-ntp true
  ```

## Disk Partitioning <a name="disk-partitioning"></a>

In this guide I assume only one disk and that the full disk is being utilized.
I use `ext4` as my primary filesystem.

My partition scheme will be as follows:

```
/efi - 200 MB (Doesn't need to be created if an EFI partition already exists)
[SWAP] - If hybernation is needed, the size of RAM or double. If not, half of RAM should suffice.
/ - 80 GB
/home - Remainder of space
```

- Determine the size of the disk and the size of RAM memory.
  I will be using and referencing `/dev/sda` as my disk.
  ```sh
  fdisk -l
  free -h
  ```
- Use `fdisk /dev/sda` to enter a command-line disk partition editor.
  In this prompt you may type `p` to view the pending partition table.
- Type `g` to create a new GPT partition scheme.
  This will also erase the old partition table along with any old partitions.
- Create an efi partition.
  Create a new partition, use the default partition number and first sector, and size the partition.
  ```
  n
  enter
  enter
  +200M
  ```
  If prompted to remove an existing filesystem signature, say `yes`.
  New signatures will be established for the new partitions.
  If you accidentally create a bad partition, you can always delete the partition using the `d` key.
- Tag the new partition as `EFI System`:
  ```
  t
  1
  ```
- Create a SWAP partition. This never needs to be very big, especially if you never plan on hibernation.
- Tag the SWAP partition as `Linux swap`:
  ```
  t
  2
  19
  ```
- Create a root `/` partition.
  ```
  n
  enter
  enter
  +80G
  ```
- Create a `/home` home partition. This partition will use the remainder of the disk space.
  ```
  n
  enter
  enter
  enter
  ```
- Type `p` to view your partitions.
  Once you are satisfied with your partitioning, type `w` to permanently write the partitioning scheme to the disk.
  You will be returned to the virtual terminal prompt, where you will be able to run `fdisk -l` to view your newly created partitions.
- Change all partition signatures.
  ```
  mkfs.fat -F 32 -n BOOT /dev/sda1
  mkswap -L SWAP /dev/sda2
  swapon /dev/sda2
  mkfs.ext4 -L ROOT /dev/sda3
  mkfs.ext4 -L HOME /dev/sda4
  ```
- Mount the partitions.
  ```
  mount /dev/sda3 /mnt
  mkdir /mnt/efi
  mount /dev/sda1 /mnt/efi
  mkdir /mnt/home
  mount /dev/sda4 /mnt/home
  ```
  You can use the `lsblk -f` command to verify that your partitions have been mounted correctly.

## Operating System Installation <a name="operating-system-installation"></a>

- Install the kernel and operating system base.
  This usually takes some time to complete depending on your internet stability.
  I also recommend installing a text editor.
  Additionally, you may consider `linux-zen` over `linux` on desktops for performance reasons.
  ```
  pacstrap /mnt base linux linux-firmware neovim networkmanager
  ```

## Fstab <a name="fstab"></a>

- Generate an Fstab file.
  This is a file that dictates how partitions are mounted when the system boots.
  ```
  genfstab -U /mnt >> /mnt/etc/fstab
  ```
  You can double check that `/mnt/etc/fstab` is formatted according to your needs
  and modify any mount options if needed.

## Chroot <a name="chroot"></a>

- Change root into the new system. You will now be within your newly-formatted disk.
  ```
  arch-chroot /mnt
  ```

## Localization <a name="localization"></a>

- Set the time zone, where REGION and CITY pertain to your local area.
  These values can be tab-completed.
  ```
  ln -sf /usr/share/zoneinfo/REGION/CITY /etc/localtime
  ```
- Sync the clock to the time zone specified.
  ```
  hwclock --systohc
  ```
- Edit `/etc/locale.gen` to enable necessary locales.
  ```
  en_US.UTF-8 UTF-8
  pt_BR.UTF-8 UTF-8
  ja_JP.UTF-8 UTF-8
  ```
  Then generate locales.
  ```
  locale-gen
  ```
- Edit `/etc/locale.conf` to set the system language:
  ```
  LANG=en_US.UTF-8
  LC_MESSAGES=en_US.UTF-8
  LC_MONETARY=pt_BR.UTF-8
  LC_PAPER=pt_BR.UTF-8
  LC_MEASUREMENT=pt_BR.UTF-8
  LC_ADDRESS=pt_BR.UTF-8
  LC_TIME=pt_BR.UTF-8
  ```
- Edit `/etc/vconsole.conf` to permanently set the console keyboard layout:
  ```
  KEYMAP=br-abnt2
  ```

## Network Configuration <a name="network-configuration"></a>

- Name your system in `/etc/hostname`. I will name mine `ghost`.
  ```
  ghost
  ```
- Create the corresponding host entries in `/etc/hosts`:
  ```
  127.0.0.1     localhost
  ::1           localhost
  127.0.1.1     ghost.localdomain    ghost
  ```
- Enable network manager.
  ```
  systemctl enable NetworkManager
  ```

## Password <a name="password"></a>

- Set the root password.
  ```
  passwd
  ```

## Boot Loader <a name="boot-loader"></a>

I use Grub as a bootloader because it is simple, quick, and works on both UEFI/BIOS systems. It also has a customizeable appearance.

- Install the bootloader.
  ```
  pacman -S grub efibootmgr
  grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
  ```
  Generate the configuration file.
  ```
  grub-mkconfig -o /boot/grub/grub.cfg
  ```

## Installation Wrapup <a name="installation-wrapup"></a>

At this point, we have completely installed everything needed for a fully functional system.

- Exit chroot and umount the partitions.
  ```
  exit
  umount -R /mnt
  ```
- Shutdown the system.
  ```
  shutdown now
  ```
  Then remove the usb drive.
- Power on the machine.
  You likely need to change the BIOS settings of your machine in order to tell your motherboard the location of the efi boot partition.

  If it boots into a bootloader menu, then stops at a login prompt, you've just successfully completed a standard Archlinux installation! However, this specific installation is anything but standard - we still have some work to do.

- Log in to root using `root` as the username and the password you created earlier.

## Post-Install Internet <a name="post-install-internet"></a>

- Connect to internet.
- If you use network manager, you can use utilities such as `nmcli` or `nmtui`.
- Verify internet connection with `ping archlinux.org`.

## Creating a User <a name="creating-a-user"></a>

- Create a new user.
  This will be the main user.
  ```
  useradd -m -G video,wheel sam
  passwd sam
  ```
- Install sudo and configure the sudoers file. Uncomment the wheel group permissions line.
  ```
  pacman -Syu --needed sudo
  EDITOR=/usr/bin/nvim visudo
  ```
- Then `logout` and log back in as the newly created user.

## Core <a name="core"></a>

- Run a system upgrade to update any packages that were not up to date when the system was installed.
  It's a good practice to do this on a clean install even if no packages need updating.
  ```
  sudo pacman -Syu
  ```
- Install git and other core utilities.
  ```
  sudo pacman -S git python
  ```
- Enable the multilib repos in `/etc/pacman.conf`:
  ```
  [multilib]
  Include = /etc/pacman.d/mirrorlist
  ```

## Cloning <a name="cloning"></a>

- Clone this repository to your home folder using the steps outlined below.
  ```sh
  cd $HOME
  git clone https://github.com/Vinesma/.dotfiles.git
  ```
- Run the install script I have created:
  ```sh
  cd $HOME/.dotfiles/install
  python main.py
  ```