# mizOS Documentation

## Section 1. Overview
Made by [https://sudev.neocities.org](https://sudev.neocities.org)

mizOS is a fork of Artix Linux, with the Runit init system.

The core of mizOS is the **miz** script. Without the **miz** script, mizOS is just Artix Linux.

The **miz** script manages the following:
- Runit services
- Package installation (pacman management)
- mizOS system updates
- AUR management (yay)
- DE and WM installation
- More to come

( mizOS also comes with i3-gaps and picom, with some sexy configuration files. )

**Why does mizOS use a hijack script, and not an ISO image?** - Because it's much more conveniant, and I still have no clue how to make a custom Artix ISO.

**wHy DOes mIzOs uSE LUa aNd nOt A LiGhtEr lANGuaGe LiKE rUsT?** - Please, shut up.

## Section 2. Installation

**Step 1** - Install Artix Linux with the Runit init system, preferably the XFCE image as it contains many tools to easily manage your system. Get the ISO [here](https://artixlinux.org/download.php).

**Step 2** - Connect to wifi.

**Step 3** - Open a terminal.

**Step 4** - Run **sudo pacman -Syu** to ensure your system has the latest packages.

**Step 5** - Enable the Universe repository, instructions [here](https://wiki.artixlinux.org/Main/Repositories)

**Step 6** - Run **sudo pacman -S artix-archlinux-support** and follow the on-screen instructions to enable the Arch Linux repositories.

**Step 7** - Run **sudo pacman -S git** to install the git package.

**Step 8** - Run **git clone https://github.com/Mizosu97/mizOS** to install the mizOS source code, then run *cd mizOS*.

**Step 9** - Run **./install** to begin the installation. If it gives a permissions error, run *chmod +x install* and try again.

## Section 3. **miz** Documentation

The **miz** script contains a lot of options (arguments). You can read up on how to use the **miz** script below.

The **miz** script has 7 main arguments. Being **system**, **service**, **pac**, **aur**, **desktop**, **wm**, and **info**.

- **system** manages mizOS system updates.
- **service** manages services (runit).
- **pac** manages pacman packages.
- **aur** manages aur packages (yay).
- **desktop** manages Desktop Environment installation.
- **wm** manages Window Manager installation.
- **info** displays information about mizOS.

###### 1. miz system
**miz system update** - Updates the **miz** script and upgrades all packages.

###### 2. miz service
**miz service link \<service\>** - Symlinks a service in /etc/runit/sv/ to /run/runit/service/

**miz service unlink \<service\>** - Removes the symlinked service.

**miz service disable \<service\>** - Prevents a service from starting at boot.

**miz service enable \<service\>** - Negates the **miz service disable** effect.

**miz service start \<service\>** - Starts a service.

**miz service stop \<service\>** - Stops a service.

**miz service restart \<service\>** - Restarts a service.

**miz service list installed** - List the services installed.

**miz service list linked** - List the services that have been symlinked to /run/runit/service/

###### 3. miz pac
**miz pac install \<package\>** - Installs that package.

**miz pac remove \<package\>** - Removes that package.

**miz pac sync** - Syncs the repos.

**miz pac update** - Upgrades all packages installed by pacman.

###### 4. miz aur
**miz aur install \<package\>** - Installs that AUR package.

**miz aur remove \<package\>** - Removes that AUR package.

**miz aur update** - Upgrades all AUR packages.

###### 5. miz desktop
**miz desktop list** - Lists the Desktop Environments you can install.

**miz desktop install \<desktop\>** - Installs that Desktop Environment.

###### 6. miz wm
**miz wm list** - Lists the Window Managers you can install.

**miz wm install \<wm\>** - Installs that Window Manager.

###### 7. miz info
**miz info help** - Links you to the GitHub.

**miz info creator** - Links you to the sudev website.

## Section 4. i3-gaps config changes.

When i3-gaps first runs, it will ask to either set the Windows Key or Alt key as the MOD key, remember the key you chose.

If you dont know how to navigate i3-gaps, follow the tutorial [here](https://i3wm.org/docs/refcard.html)

Changes mizOS makes to i3-gaps:
- Catppuccin color scheme.
- Wallpaper.
- MOD+shift+a now lets you take a screenshot, the image will be saved to your clipboard.
- MOD+shift+p enables second monitor support, this only works on certain setups.
- MOD+shift+m enables Picom for some fancy blur effects.
- MOD+shift+n disables Picom.
