---
title: Dependencies
keywords: workflow modern
last_updated: January 23, 2025
tags: [tools modern includes]
summary: ""
permalink: mydoc_pnp_dependency.html
folder: mydoc
---

Your mulle-objc project will have dependencies. One dependency is either the
MulleObjC library or the Foundation library and their constituent libraries.
But you will likely want to add more.

mulle-sde makes this easy and in the best case a one-liner. Here's
how.

## mulle-sde dependency manages the sourcetree

All dependencies are managed via a *sourcetree*. If you have created a
mulle-sde project as described previously, you can look at the pre-defined
sourcetree with `mulle-sde dependency list` or  `mulle-sourcetree list`
(use `-l -u` for more detail).

```
| address
|--------
| Foundation
| Foundation-startup
```

These dependencies again can be mulle-sde and non mulle-sde projects.
Each mulle-sde project in turn may have its own sourcetree with
dependencies. So you can see where this is heading...


## Add a repository from github

When adding a third-party repository, the first thing to decide is, if it is
a C or an Objective-C repository. At this point in time  C is more likely, so
we will go with that first.

For github repositories there is a special syntax available, so you don't have
to type in the whole URL. This command adds
[https://github.com/libexpat/libexpat]() to your project:

### C:

``` console
mulle-sde dependency add --c github:libexpat/libexpat
```

This command adds
[https://github.com/MulleWeb/MulleZlib]() to your project:

### Objective-C:

``` console
mulle-sde dependency add github:MulleWeb/MulleZlib
```

## Get build commands for free

**libexpat** is special, in that there is a **craftinfo** available for it.
Many libraries can be built without a **craftinfo**, but for some libraries
like **libexpat** a few tweaks are desirable. The **craftinfo** contains these
tweaks.

You can look at the [craftinfo](https://github.com/craftinfo) site to see
what is available.

> If you have a craftinfo, that you would like to share, you are very welcome
> to contribute this craftinfo.

{% include tip.html content="You can examine and manipulate craftinfos with the
`mulle-sde dependency craftinfo` command." %}


## Header and link commands are automatically created

`mulle-sde reflect` will reflect the contents of the sourcetree into **cmake** files
residing under `./cmake` and into header files residing under `./src`.
This means you will not have to write any `#include` statements or add link
commands to your project. As dependencies are recursive, you also won't have to
figure out against which system library to link.

### Fix a missing include

Often mulle-sde can not guess the correct name and location of the central
include header of a dependency correctly. This can be rectified with:

``` console
mulle-sde dependency set libexpat include "expat.h"
mulle-sde reflect
```

### Fix a missing library

More rarely a library can not be found, because the name differs from the
project. Fix this with:

``` console
mulle-sde dependency set libexpat aliases eXpat
mulle-sde reflect
```

{% include tip.html content="There is a lot more information about
mulle-sde and various kinds of dependencies available in the
[mulle-sde Wiki](https://github.com/mulle-sde/mulle-sde/wiki)."
%}

## Remove dependency

Removing a dependency again is as easy as typing `mulle-sde dependency
remove libexpat` and letting `mulle-sde reflect` reflect the changes back into
cmake and header files.


## Next

A more detailed look at how a mulle-sde project deals with
[header](mydoc_pnp_source.html) sources.
