# Installation

mizOS installation is very simple. All you need is a working install of any supported Arch-based distro, and the commands below.

## Pre-Installation

- Add the g14 repo to `/etc/pacman.conf`

[g14]
SigLevel = DatabaseNever Optional TrustAll
Server = https://arch.asus-linux.org

- Update your system with `sudo pacman -Syu`
- On an Artix system, you need to enable the Arch Linux repositories. [tutorial here](https://wiki.artixlinux.org/Main/Repositories)
- Make sure you have the `git` package installed with `sudo pacman -S git`
- As an added precaution, install the `lua` package with `sudo pacman -S lua`

## Install mizOS

- Download mizOS with `git clone https://github.com/Mizosu97/mizOS`
- Change your directory into mizOS with `cd mizOS`
- Run `./install` to install mizOS

## Tested Operating Systems

mizOS installation has been officially tested on the following operating systems:

- Artix-runit
