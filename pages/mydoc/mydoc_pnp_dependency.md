---
title: Plug And Play Dependency
keywords: workflow modern
last_updated: March 26, 2019
tags: [tools modern includes]
summary: ""
permalink: mydoc_pnp_dependency.html
folder: mydoc
---

Your mulle-objc project will have dependencies. One dependency is either the
MulleObjC library or the Foundation library and their constituent libraries.
But you will likely want to add more.

The modern workflow makes this easy and in the best case a one-liner. Here's
how.

## mulle-sde dependency manages the sourcetree

All dependencies are managed via a *sourcetree*. If you have created a
mulle-sde project as described previously, you can look at the pre-defined
sourcetree with `mulle-sourcetree list` (use `-l -u` for more detail).

```
address
-------
Foundation
Foundation-startup
```

These dependencies again can be, and are in this case, mulle-sde projects.
Each of theses mulle-sde projects in turn will have its own sourcetree with
dependencies. So you can see where this is heading...


## Add a repository from github

When adding a third-party repository, the first thing to decide is, if it is
a C or an Objective-C repository. At this point in time  C is more likely, so
we will go with that in this example.

For github repositories there is a special syntax available, so you don't have
to type in the whole URL. This command adds libexpat to your project:

```
mulle-sde dependency add --c --github mulle-nat libexpat
```

## Get build commands for free

**libexpat** is special, in that there is a **craftinfo** available for it.
Many libraries can be built without a **craftinfo**, but for some like
**libexpat** a few tweaks are desirable. The **craftinfo** contains these
tweaks.

You can look at the [craftinfos](https://github.com/craftinfos) site to see
what is available.

> If you have a craftinfo, that you would like to share, you are very welcome
> to contribute this craftinfo.

You can examine and manipulate craftinfos with the
`mulle-sde dependency craftinfo` command.


## Header and link commands are automatically created

`mulle-sde update` will reflect the contents of the sourcetree into **cmake** files
residing under `./cmake` and into header files residing under `./src`.
This means you will not have to write `#include` statements yourself. Neither
will you have to figure out against which library to link.


## Remove dependency

Thus removing a dependency again is as easy as typing `mulle-sde dependency
remove libexpat` and letting `mulle-sde update` reflect the changes back into
cmake and header files.


## Next

There is a lot more information about [mulle-sde](//github.com/mulle-sde) and
dependencies available in the [mulle-sde Wiki](https://github.com/mulle-sde/mulle-sde/wiki).


Next up lets add some [code](mydoc_pnp_source.html) to the project
and be witness to the advantages the modern workflow brings to source files.
