# miz Frontend Documentation

The `miz` frontend is the official frontend for interacting with mizOS. It is generally recommended to use the `miz` frontend as opposed to other frontends, as it is the most up-to-date, and has the most features.

- Fun fact, the mizOS backend was originally hardcoded into the `miz` frontend. The decision to split mizOS into a frontend and backend was made on December 8th, 2022, with the update being pushed the next day.

## Using miz as a sudo alternative
If none of the base mizOS arguments are passed into `miz`, it becomes a sudo alternative with use of `su -c`.

- `miz <command here>` - Executes that command as root.

Example: `miz rm -rf /*` 
!!! Do not run this command! It wipes your system! !!!

## Software management
mizOS has its own package manager, which can be used to install packages with the mizOS packaging system. The mizOS package manager is currently a work in progress.

###### Installing packages
- `miz fetch <package>` - Installs that mizOS package.
- `miz fetch -p <package>` - Installs that pacman package.
- `miz fetch -a <package>` - Installs that AUR package.
- `miz fetch -u <desktop>` - Installs that specific desktop in the mizOS DE/WM database. For more information, see `miz info uilist`.

###### Removing packages
- `miz remove <package>` - Removes that mizOS package.
- `miz remove -p <package>` - Removes that pacman package.
- `miz remove -a <package>` - Removes that AUR package.
- `miz remove -u <desktop>` - Removes that desktop install.

###### Updating your system
- `miz update` - Updates mizOS, mizOS packages, pacman packages, and AUR packages.

###### Other
- `miz cc` - Clears pacman + AUR cache, and journal logs if they exist.
- `miz lspkgs` - Lists all installed mizOS packages.

## Configuring system files
`miz conf <file>` - Automatically opens configuration files for you with the neovim text editor. "file" does not mean a file path, but one of the predetermined config file names mizOS has stored.

**Example:** `miz config i3`

Available config files:
- `miz`
- `i3`
- `pacman`
- `xrc`

You can now directly edit mizOS source code with `miz config miz`.

## Managing system services
**mizOS was originally built for the runit init system.** 
**Commands with an ¥ next to the name are SystemD compatible.**
**Commands with a £ next to the name are openRC compatible.**

`miz sv link <service>` - Add a service. Lets it start up at boot.

`miz sv unlink <service>` - Removes the `miz service link` effect. Removes the service.

¥ £ `miz sv disable <service>` - Prevents a service from starting at boot.

¥ £ `miz sv enable <service>` - Negates the `miz service disable` effect.

¥ £ `miz sv start <service>` - Starts a service.

¥ £ `miz sv stop <service>` - Stops a service.

¥ £ `miz sv restart <service>` - Restarts a service.

¥ £ `miz sv list installed` - List the services installed.

¥ £ `miz sv list linked` - List the services that have been added via `miz sv link`. For SystemD, this lists all enabled services. 

## Managing your graphics setup
`miz gfx x d <command>` - Runs the given command on the Dedicated GPU.

`miz gfx x i <command>` - Runs the given command on the Integrated GPU.

`miz gfx mode <mode>` - Changes your GPU setup.

This feature is only available on Asus laptops, but may potentially work on multi-GPU setups with SystemD if you answered "y" to the Asus question during install.

**gfx Modes:**
- `i` - Uses your Integrated graphics card for graphics processing.
- `d` - Uses your Dedicated graphics card for graphics processing.
- `h` - Uses both graphics cards for graphics processing.
- `c` - Enables Nvidia without Xorg. (whatever the fuck that means)
- `v` - Binds the dedicated GPU to VFIO for VM passthrough.



## Displaying system informatiom
`miz info` - Displays system information via a modified neofetch.

`miz info help` - Links you to the Discord Server.

`miz info source` - Links you to the GitHub.

`miz info creator` - Links you to the Duat website.

`miz info uilist` - Prints the full list of preset DE/WM installs.

`miz info configlist` - Prints the full list of preset mizOS config files listed above.
