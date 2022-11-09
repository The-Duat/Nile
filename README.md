# mizOS Documentation

- Please note, mizOS is in VERY early development.

Made by [https://theduat.neocities.org](https://theduat.neocities.org)
```
! PLEASE READ ! 

After installation DO NOT use `sudo pacman -Syu` to update your system. Use `miz update` instead. Also, installing the `neofetch` package will break the custom neofetch mizOS provides.

mizOS was something I created for my own personal use. mizOS installs some "bloat" that you probably don't want. All of this fixes some things that I personally don't like about typical Linux distros. I suggest not installing it as your daily driver, but I'm not stopping you either.
```

mizOS is a Linux distro focused on simplicity. It aims to centralize a lot of commands I typically use frequently, or are generally long/can't remember the name of. It puts everything under somewhat of an alias via a script called `miz`. mizOS takes a janky Arch Linux install, and turns it into something more polished towards my liking. I've also added a preconfigured i3-gaps installation, but I'm thinking of changing this to Gnome sometime.

Instead of providing a normal Arch Linux ISO with an installation script on it, mizOS assumes that you already have a working Arch Linux or Arch Linux-based installation, and requires you to manually download and run the installation script. The installation script will "hijack" the current system that is installed, and install the mizOS tools onto it. Thus turning it into mizOS, much like the Bedrock Linux installation procedure. This allows you to turn theoretically any Arch-based Linux distrbution into mizOS, even something like Artix Linux.

mizOS currently supports the following init systems:
- Runit
- SystemD
- OpenRC


Pages:

[Installing mizOS](https://github.com/Mizosu97/mizOS/blob/main/pages/install.md)

[Using the miz script](https://github.com/Mizosu97/mizOS/blob/main/pages/miz.md)

[How do I use i3-gaps?](https://github.com/Mizosu97/mizOS/blob/main/pages/i3.md)
