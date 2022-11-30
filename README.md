# mizOS Documentation
Developed by [The Duat](https://theduat.neocities.org).

- Please note, mizOS is in VERY early development.

```
! PLEASE READ ! 

I HIGHLY recommend that you don't install mizOS as your
daily driver. mizOS was made for me to personally use.
Some aspects of mizOS are generally seen as bad, and 
have the potential to break. 

If you  r e a l l y  want to install mizOS, I won't
stop you. But just know that what you're getting into 
might just be hell.
```


mizOS is a Linux Distro I created to perfectly suit my needs when it comes to how I want to use my system. It has everything I need, and gets additions whenever I feel like I need to add something.

Nearly everything mizOS-related is controlled with a script called `miz`. `miz` is the heart of mizOS.

Some features of mizOS include but are not limited to:
- Finer hardware control for Asus laptop owners.
- It's own packaging system + package manager for user-created packages.
- Standardization of "init system" commands. 

There are 2 ways to install mizOS. You can either use the ISO image, or you can "hijack" a current Arch Linux or Arch Linux-based operating system already installed on your device, and convert it into mizOS.

- The ISO image currently only supports SystemD. If you want to use a diffferent init system, you must use the hijack method.

- If you want to install mizOS onto an Asus laptop, you MUST use SystemD. `asusctl` and `supergfxctl` are simply not compatible with other init systems.

mizOS currently supports the following init systems:
- Runit
- SystemD
- OpenRC


**Pages:**

[Installing mizOS](https://github.com/Mizosu97/mizOS/blob/main/pages/install.md)

[Using the miz script](https://github.com/Mizosu97/mizOS/blob/main/pages/miz.md)

[The mizOS package manager](https://github.com/Mizosu97/mizOS/blob/main/pages/pkg.md)

[How do I use i3-gaps?](https://github.com/Mizosu97/mizOS/blob/main/pages/i3.md)


