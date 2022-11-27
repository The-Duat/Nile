# Installation

There are 2 ways to install mizOS. You can either use the ISO image, or you can "hijack" a current Arch Linux or Arch Linux-based operating system already installed on your device, and convert it into mizOS.                                                                             The ISO image currently only supports SystemD. If you want to use a diffferent init system, you must use the hijack method.

# Method 1: Using the ISO image.

The ISO image is still in development, and may not work properly.

## Pre-Installation

- Get the ISO image [here](https://github.com/Mizosu97/mizos_iso), and flash it to some form of external storage. Or load it into a virtual machine, whatever suits your needs.

- Boot from the ISO image.

## Install mizOS

Once booted into the live GNOME environment, there are a couple things you need to do.

The password for both the user and the root account on the live image is "123".

- Open a terminal.

- If you are using a wifi connection, start Network Manager with the command `sudo systemctl enable NetworkManager && sudo systemctl start NetworkManager`. Then connect to wifi by either using `nmtui` or `gnome-control-panel`.

- Now, you can start the mizOS installation with the command `sudo chmod +x /usr/local/bin/install_mizos && install_mizos`.



**Important Notes:**
- In the installation menu, you must select "NetworkManager" as the network, or the installation will fail.
- When the menu asks if you want to chroot into the new install, select "No".

- After selcting "No", follow the password prompts on the screen. The password prompts are talking about the passwords you have set for the installed root and user accounts, not the accounts on the live image.

# Method 2: Hijacking a pre-existing Arch Linux install.
Hijacking an install gives more flexibilty on how you want your mizOS installation to be. You can even hijack an install with an init system that is not SystemD, as long as it is either Runit or OpenRC.

## Pre-Installation

- Add the g14 repo to `/etc/pacman.conf`.

```
[g14]
SigLevel = DatabaseNever Optional TrustAll
Server = https://arch.asus-linux.org
```

- On an Artix system, you need to enable the Arch Linux repositories. [tutorial here](https://wiki.artixlinux.org/Main/Repositories).
- Update your system with `sudo pacman -Syu`.
- Make sure you have the `git` package installed with `sudo pacman -S git`.
- As an added precaution, install the `lua` package with `sudo pacman -S lua`.

## Install mizOS

- Download mizOS with `git clone https://github.com/Mizosu97/mizOS`
- Change your directory into mizOS with `cd mizOS`
- Run `./install` to install mizOS

## Tested Operating Systems

The mizOS hijack installation has been officially tested on the following operating systems:

- Artix-runit
- Arch Linux
