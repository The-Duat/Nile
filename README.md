# mizOS Documentation
Developed by [The Duat](https://entertheduat.org).


```
! PLEASE READ ! 

mizOS is in very early development. It is not currently recommended
to install mizOS as your daily driver. Some features are still
experimental, and may break. This warning will be removed when
mizOS developments starts to stabilize.
```

## What is mizOS?

mizOS is an Arch Linux-based operating system which aims to provide a simple, easy-to-use system without sacrificing performance or system resources.


Some features of mizOS include, but are not limited to:
- A lightweight user interface via a customized i3-gaps installation.
- Finer hardware control for Asus laptop owners.
- It's own packaging system + package manager for official, and user-created packages.
- Standardization of "init system" commands.
- Centralization, and simplification of common system commands.


## How do I Install mizOS?
There are 2 ways to install mizOS. You can either use the ISO image, or you can "hijack" a current Arch Linux or Arch Linux-based operating system already installed on your device, and convert it into mizOS.


- The ISO image currently only supports SystemD. If you want to use a different init system, you must use the hijack method.


- If you want to install mizOS onto an Asus laptop, you MUST use SystemD. The tools `asusctl` and `supergfxctl`, which are a necessity on Asus laptops, are simply not compatible with other init systems.

The hijack method currently supports the following init systems:
- Runit
- SystemD
- OpenRC

For a detailed installation tutorial, see [Installing mizOS](https://github.com/Mizosu97/mizOS/blob/main/pages/install.md).


## How do I Use mizOS?
All of the code that operates mizOS is stored in a single file called `mizOS.lua`. This file is referred to as "the backend".  Code stored inside the backend can be externally executed by other files. This means that you can have multiple different programs that manage mizOS, and perform mizOS functions. These programs are called "frontends".

mizOS provides an official frontend for managing mizOS; a program called `miz`. `miz` is automatically installed with mizOS, and is the most up-to-date frontend available.

For information on using `miz`, see [Using the miz Frontend](https://github.com/Mizosu97/mizOS/blob/main/pages/miz.md).


On top of pacman and the AUR, mizOS has it's own Github-centric package manager. This package manager can be used to install official mizOS packages, and also user-created packages. See [The mizOS Package Manager](https://github.com/Mizosu97/mizOS/blob/main/pages/pkg.md).


As previously mentioned, mizOS comes with a preconfigured i3-gaps installation as its default user interface.

i3-gaps may be a little tricky for users new to window managers. See [How Do I Use i3-gaps?](https://github.com/Mizosu97/mizOS/blob/main/pages/i3.md)


