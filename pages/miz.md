# miz Script Documentation

The core of mizOS is the `miz` script (and i3+picom configurations). Without `miz`, mizOS is just whatever Arch distro you have installed.

The `miz` script does the following:
- Manages services
- Manages packages via `pacman`
- Manages mizOS system updates
- Manages AUR packages via `yay`
- Manages DE and WM installation
- Gives you more control of your GPUs
- Enables easy accesibility to config files
- Displays information about mizOS
- More to come


The `miz` script contains a lot of options (arguments). You can read up on how to use the `miz` script below.



The `miz` script has 6 main arguments. Being `update`, `config`, `service`, `gfx`, `sw`, and `info`.

- `update` manages mizOS system updates.
- `config` gives easy access to configuration files.
- `service` manages services.
- `gfx` manages GPU and graphics-related things.
- `sw` manages software installation.
- `info` displays information about mizOS.

## miz update
`miz update` - Updates mizOS, pacman packages, and AUR packages.

## miz config
`miz config <file>` - Automatically opens configuration files for you with the neovim text editor. "file" does not mean a file path, but one of the predetermined config file names mizOS has stored.

**Example:** `miz config i3`

Available config files:
- `miz`
- `i3`
- `pacman`
- `xrc`

You can now directly edit mizOS source code with `miz config miz`.

## miz service

**mizOS was originally built for the runit init system.** 
**Commands with an ¥ next to the name are SystemD compatible.**
**Commands with a £ next to the name are openRC compatible.**

`miz service link <service>` - Add a service. Lets it start up at boot.

`miz service unlink <service>` - Removes the `miz service link` effect. Removes the service.

¥ £ `miz service disable <service>` - Prevents a service from starting at boot.

¥ £ `miz service enable <service>` - Negates the `miz service disable` effect.

¥ £ `miz service start <service>` - Starts a service.

¥ £ `miz service stop <service>` - Stops a service.

¥ £ `miz service restart <service>` - Restarts a service.

¥ £ `miz service list installed` - List the services installed.

¥ £ `miz service list linked` - List the services that have been added via `miz service link`. For SystemD, this lists all enabled services. 

## miz gfx
`miz gfx run d <command>` - Runs the given command on the Dedicated GPU.

`miz gfx run i <command>` - Runs the given command on the Integrated GPU.

`miz gfx mode <mode>` - Changes the your GPU setup. Modes are listed below.
- `i` - Uses your Integrated graphics card for graphics processing.
- `d` - Uses your Dedicated graphics card for graphics processing.
- `h` - Uses both graphics cards for graphics processing.
- `c` - Enables Nvidia without Xorg. (whatever the fuck that means)
- `v` - Binds the dedicated GPU to VFIO for VM passthrough.

## miz sw
`miz sw fetch <package>` - Installs that package.

`miz sw remove <package>` - Removes that package.

- Adding the `-aur` flag after `fetch` or `remove` will direct the command to yay instead of pacman, allowing you to install AUR packages.

**Example:** `miz sw fetch -aur grapejuice-git`.

- Adding the `-ui` flag after `fetch` or `remove` will install packages based on the preset DE/WM list. Currently, you can only install one desktop at a time.

**Example:** `miz sw fetch -ui kde`.

- Adding the `-custom` flag after `fetch` or `remove` allows you to automatically install custom mizOS packages. This feature is not yet implemented.

`miz sw cc` - Clears the pacman and AUR cache. Also clears journal logs.




## miz info
`miz info help` - Links you to the Discord Server.

`miz info source` - Links you to the GitHub.

`miz info creator` - Links you to the Duat website.

`miz info uilist` - Prints the full list of preset DE/WM installs.

`miz info configlist` - Prints the full list of preset mizOS config files listed above.
