# mizOS Documentation
Developed by [The Duat](https://theduat.neocities.org).

- Please note, mizOS is in VERY early development.

```
! PLEASE READ ! 

After installation DO NOT use `sudo pacman -Syu` to update your system.
Use `miz update` instead. Also, installing the `neofetch` pacman 
package will break the custom neofetch mizOS provides.

mizOS was something I created for my own personal use. mizOS installs
some "bloat" that you probably don't want. All of this fixes some
things that I personally don't like about typical Linux distros. I
suggest not installing it as your daily driver, but I'm not stopping
you either.
```


mizOS is a Linux distro focused on simplicity. It aims to centralize a lot of commands I typically use frequently, or are generally long/can't remember the name of. It puts everything under somewhat of an alias via a script called `miz`. mizOS takes a janky Arch Linux install, and turns it into something more polished towards my liking. mizOS also comes with some features geared more towards gaming laptops, such as finer GPU management. mizOS also has some other features, such as a preconfigured i3-gaps installation, and its very own package manager.

There are 2 ways to install mizOS. You can either use the ISO image, or you can "hijack" a current Arch Linux or Arch Linux-based operating system already installed on your device, and convert it into mizOS.

The ISO image currently only supports SystemD. If you want to use a diffferent init system, you must use the hijack method. 

mizOS currently supports the following init systems:
- Runit
- SystemD
- OpenRC


**Pages:**

[Installing mizOS](https://github.com/Mizosu97/mizOS/blob/main/pages/install.md)

[Using the miz script](https://github.com/Mizosu97/mizOS/blob/main/pages/miz.md)

[The mizOS package manager](https://github.com/Mizosu97/mizOS/blob/main/pages/pkg.md)

[How do I use i3-gaps?](https://github.com/Mizosu97/mizOS/blob/main/pages/i3.md)


