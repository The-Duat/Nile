# miz Script Documentation

The core of mizOS is the `miz` script (and i3+picom configurations). Without `miz`, mizOS is just whatever Arch distro you have installed.

The `miz` script does the following:
- Manages services
- Manages packages via `pacman`
- Manages mizOS system updates
- Manages AUR packages via `yay`
- Manages DE and WM installation
- Displays information about mizOS
- More to come


The `miz` script contains a lot of options (arguments). You can read up on how to use the `miz` script below.



The `miz` script has 7 main arguments. Being `system`, `service`, `pac`, `aur`, `desktop`, `wm`, and `info`.

- `system` manages mizOS system updates.
- `service` manages services (runit).
- `pac` manages pacman packages.
- `aur` manages aur packages (yay).
- `desktop` manages Desktop Environment installation.
- `wm` manages Window Manager installation.
- `info` displays information about mizOS.

## miz system
`miz system update` - Updates mizOS.

## miz service

**mizOS was originally built for the runit init system. Commands with an ¥ next to the name are SystemD compatable.**

`miz service link <service>` - Add a service. Lets it start up at boot.

`miz service unlink <service>` - Removes the `miz service link` effect. Removes the service.

¥ `miz service disable <service>` - Prevents a service from starting at boot.

¥ `miz service enable <service>` - Negates the `miz service disable` effect.

¥ `miz service start <service>` - Starts a service.

¥ `miz service stop <service>` - Stops a service.

¥ `miz service restart <service>` - Restarts a service.

¥ `miz service list installed` - List the services installed.

¥ `miz service list linked` - List the services that have been added via `miz service link`. For SystemD, this lists all enabled services. 

## miz pac
`miz pac fetch <package>` - Installs that package.

`miz pac remove <package>` - Removes that package.

`miz pac sync` - Syncs the repos. (Arch devs don't like you doing this. Has potential to break a system.)

## miz aur
`miz aur fetch <package>` - Installs that AUR package.

`miz aur remove <package>` - Removes that AUR package.

`miz aur update` - Upgrades all AUR packages.

## miz desktop
`miz desktop list` - Lists the Desktop Environments you can install.

`miz desktop fetch <desktop>` - Installs that Desktop Environment.

## miz wm
`miz wm list` - Lists the Window Managers you can install.

`miz wm fetch <wm>` - Installs that Window Manager.

## miz info
`miz info help` - Links you to the GitHub.

`miz info creator` - Links you to the sudev website.

