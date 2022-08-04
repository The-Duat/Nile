# mizOS Documentation

## Section 1. Intro
mizOS is a fork of Artix Linux, with the Runit init system.

The core of mizOS is the **miz** script. Without the **miz** script, mizOS is just Artix Linux.

The **miz** script manages the following:
- Runit services
- Package installation (pacman management)
- Desktop Environment installation
- mizOS system updates
- More to come

( mizOS also comes with i3-gaps and picom, with some sexy configuration files. )

## Section 2. **miz** Documentation

The **miz** script contains a lot of options (arguments). You can read up on how to use the **miz** script below.

The **miz** script has 4 main arguments. Being **system**, **service**, **pac**, and **aur**.

- **system** manages mizOS system updates.
- **service** manages services (runit).
- **pac** manages pacman packages.
- **aur** manages aur packages (yay).
- **desktop** manages Desktop Environment installation.

###### 1. miz system
**miz system update** - Updates the **miz** script and upgrades all packages.

###### 2. miz service
**miz service link <service>** - Symlinks a service in /etc/runit/sv/ to /run/runit/service/

**miz service unlink <service>** - Removes the symlinked service.

**miz service disable <service>** - Prevents a service from starting at boot.

**miz service enable <service>** - Negates the **miz service disable** effect.

**miz service start <service>** - Starts a service.

**miz service stop <service>** - Stops a service.

**miz service restart <service>** - Restarts a service.

**miz service list installed** - List the services installed.

**miz service list linked** - List the services that have been symlinked to /run/runit/service/

###### 3. miz pac
**miz pac install <package>** - Installs that package.

**miz pac remove <package>** - Removes that package.

**miz pac sync** - Syncs the repos.

**miz pac update** - Upgrades all packages installed by pacman.

###### 4. miz aur
**miz aur install <package>** - Installs that AUR package.

**miz aur remove <package>** - Removes that AUR package.

**miz aur update** - Upgrades all AUR packages.
