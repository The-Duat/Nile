# mizOS Documentation

- Please note, mizOS is in VERY early development.

Made by [https://theduat.neocities.org](https://theduat.neocities.org)

! PLEASE READ ! After installation DO NOT use `sudo pacman -Syu` to update your system. Use `miz system update` instead. Also, installing the `neofetch` package will break the custom neofetch mizOS provides.

mizOS is an operating system that lets you easily run linux on Asus ROG laptops. While distros like Arch Linux run perfectly fine when you set it up right, some people just dont want to go through the hassle of manually setting up all the tools. With mizOS, you can easily set up things like asusctl, supergfxctl, and easily manage a multi-gpu setup.

mizOS doesnt use the standard ISO image for installation. It uses what's called a "hijack" script, much like Bedrock Linux. It installs on top of a pre-existing OS, allowing a lot of flexibility on how you want your system to be. mizOS only supports Arch-based operating systems.

The core of mizOS is a script called `miz`. `miz` aims to bring centralization and unification to many important system commands. It also comes with i3-gaps, along with a modified configuration file that adds some nice features.

mizOS currently supports the following init systems:
- Runit
- SystemD 


Pages:

[Installing mizOS](https://github.com/Mizosu97/mizOS/blob/main/pages/install.md)

[Using the miz script](https://github.com/Mizosu97/mizOS/blob/main/pages/miz.md)

[How do I use i3-gaps?](https://github.com/Mizosu97/mizOS/blob/main/pages/i3.md)
