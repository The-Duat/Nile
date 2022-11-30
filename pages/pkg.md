# The mizOS package manager
**!! Warning. mizOS packages are user-created content. They are not moderated. Before installing a mizOS package, please check to make sure it is safe to install. !!**


The mizOS package manager is a Github-centric package manager. Each package is stored on a Github repository, which follows the mizOS packaging format.

A mizOS package name consists of 2 parts. The developer name, and the software name.

Let's look at the package name `orwell/tool`.
- `orwell` is the first part of the package name. It is the Github account name of the package developer.
- `tool` Is the second part of the package name. It is the name of the Github repository where the package is being stored. 

Here is an example of installing/uninstalling `orwell/tool`:
- `miz fetch orwell/tool`
- `miz remove orwell/tool`

mizOS keeps track of package dependencies, files, and folders for you, so installation and uninstallation take place seamlessly.

You do not need to apply to add a package to mizOS, or go through a waiting list. All you need to do is upload your package to Github.

If you want to make a mizOS package, or want a better understanding on how mizOS packages work, see [here](https://github.com/Mizosu97/mizOSPKGTemplate).
