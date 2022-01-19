# Arch + LVM/LUKS Guide

## Disk Partitioning

The steps for partioning the disk are slightly different when using LVM.

With LVM you can just use one partition for the entire device you wish to use, this partition is a PV (Physical Volume). It can be grouped with other PVs in what's called a VG (Volume Group). The VG forms the pool of disk space on which you can "partition" into an LG (Logical Volume). A typical LVM user has multiple LGs which are roughly analogous to a normal partition. Except LVM allows easy resizing of partitions to fit the user's needs.

- First, determine if an /efi partition already resides on the disk. If so, you can't use it with LVM, as other operating systems (notably Windows) have no support for LVM. If there isn't one, you have to create a normal partition to hold the bootloader and another normal partition for LVM as instructed.

- My partition scheme with LVM will be as follows:
  ```
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
- Create a new partition, use the default partition number and sectors, and size the partition.
  ```
  n
  enter
  enter
  enter
  ```
- Type `p` to view your partitions.
  Once you are satisfied with your partitioning, type `w` to permanently write the partitioning scheme to the disk.
  You will be returned to the virtual terminal prompt, where you will be able to run `fdisk -l` to view your newly created partitions.
- You will now start using LVM. To create a PV on the new partition run:
  ```
  pvcreate /dev/sda1
  ```
- Check pvs with the command:
  ```
  pvs
  ```
- Repeat the pv creation process for every hard disk you have/wish to use.
- Now you can group your PVs into a VG:
  ```
  vgcreate GroupName /dev/sda1 /dev/sdaX /dex/sdbX ...
  ```
- Activate your VG:
  ```
  vgchange -a y GroupName
  ```
- Finally, this is the "partitioning" step, create your LVs by specifying their size, the VG they are part of and their name:
- Starting with SWAP:
  ```
  lvcreate -L 8G GroupName -n swap
  ```
- Now root:
  ```
  lvcreate -L 80G GroupName -n root
  ```
- And home, use `+100%FREE` to use the remainder of the space in the VG:
  ```
  lvcreate -l +100%FREE GroupName -n home
  ```
- Now you can format the LVs with a filesystem:
  ```
  mkswap -L SWAP /dev/GroupName/swap
  swapon /dev/GroupName/swap
  mkfs.ext4 -L ROOT /dev/GroupName/root
  mkfs.ext4 -L HOME /dev/GroupName/home
  ```
- And mount them:
  ```
  mount /dev/GroupName/root /mnt
  mkdir /mnt/home
  mount /dev/GroupName/home /mnt/home
  ```
  You can use the `lsblk -f` command to verify that your partitions have been mounted correctly.

That's it for partitioning the drive.

## Partitioning with encryption

- In the case of encryption however, the steps change slightly. Only one proper partition is created at first.
- This partition is encrypted:
  ```
  cryptsetup luksFormat /dev/sda1
  ```
- And then opened for modifications:
  ```
  cryptsetup open /dev/sda1 CryptPartitionName
  ```
- The steps for LVM are then done on top of CryptPartitionName. Which can be found at `/dev/mapper/CryptPartitionName`

## mkinitcpio

This step is taken just before installing the bootloader.

- For LVM to work, a hook needs to be set in `/etc/mkinitcpio.conf` scroll down to the HOOKS section and add `lvm2` to the array before `filesystems`, if using encryption, also add in `encrypt` before `lvm2`:
  ```
  HOOKS=(base udev autodetect modconf block encrypt[!] lvm2[!] filesystems keyboard fsck)
  ```
- Now run:
  ```
  mkinitcpio -p linux
  ```

## Decrypt with GRUB

- Special configuration is needed for GRUB when using LUKS. Grab your `/dev/sda1` UUID and open `/etc/default/grub` for editing, adding the following line in `GRUB_CMDLINE_LINUX`, changing ID_HERE with the actual UUID:
  ```
  cryptdevice=UUID=ID_HERE:CryptPartitionName root=/dev/GroupName/root
  ```
- Then regenerate GRUB config.
