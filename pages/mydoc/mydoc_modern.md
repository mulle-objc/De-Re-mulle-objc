---
title: Modern Workflow
keywords: class
last_updated: March 26, 2019
tags: [tools modern]
summary: ""
permalink: mydoc_modern.html
folder: mydoc
---

The preferred development workflow is the "modern worflow".
The modern workflow is static library based. You can also use the
[legacy workflow](mydoc_legacy.html), which is shared library based.


The advantages of the static library approach are:

* static linking works on platforms that do not support dynamic libraries
* static linking can be optimized to remove unused classes and categories
* static linking produces executables that are easier to install and deploy


## Foundation vs MulleObjC

There are two starting points. If you want a full class system with strings,
containers and OS support, you will want to base your code on the **Foundation**.
This will be the default.

If you just want to play with a minimal runtime base your code on **MulleObjC**.
Instead of `-m foundation/objc-developer` use `-m mulle-objc/objc-developer`


## Quick example "Hello World"

Generate a new executable project with:

``` console
mulle-sde init -m foundation/objc-developer -d hello-world executable
cd hello-world
```

Your project filesystem structure on your file system will be something like:

```
hello-world
├── .mulle   // mulle-sde configuration
│   ├── share
│   │   └── ...
│   ├── etc
│   │   └── ...
│   └── var
│       └── ...
├── cmake    // mulle-sde-developer cmake files
│   ├── DependenciesAndLibraries.cmake
│   ├── Headers.cmake
│   ├── share   
│   │   └── ...
│   └── Sources.cmake
├── CMakeLists.txt  // cmake project
├── README.md       // documentation
└── src             // source directory
    ├── import.h    
    ├── import-private.h
    ├── main.m
    ├── _myexe-import.h         // recreated by reflect
    ├── _myexe-import-private.h // recreated by reflect
    └── version.h
```

You can see the demo source in `src/main.m`. You are ready to craft your executable and run it. The following
part will be quite slow the first time, as mulle-sde will setup a virtual environment of your project, which 
is something akin to creating a `docker container`. But it will only have to do this once:

``` console
mulle-sde craft
./kitchen/debug/hello-world
```

{% include tip.html content="All folders named `share` are considered upgradable by
mulle-sde. They will be wiped and recreated when you do a `mulle-sde upgrade` sometime
into the future. You should not edit their contents. Similiarly folders called `var`
are used for temporary content and may be wiped and recreated by commands. %}

## Edit your project 

You can use any IDE you like, but I suggest [Sublime Text](https://www.sublimetext.com/) or [VSCode](https://code.visualstudio.com/) in the beginning.
Both run on all major platforms (like mulle-objc is supposed to). And there are extensions for them, 
that remove quite a bit of tedious set up:

```
mulle-sde extension add sublime-text # will create hello-world.sublime-project
mulle-sde extension add vscode       # will create hello-world.code-workspace
```

## Adding files to or removing files from a project

Source files live in the `src` folder of your project (can be changed with `PROJECT_SOURCE_DIR`).

The most convenient way to add files is with the `mulle-sde add` command, as this gives you 
template produced implementation and interface files for a new class. 
If you use a `+` in your filename, you will get files for category.

```
mulle-sde add src/Foo.m
mulle-sde add src/Foo+Stuff.m
```

You can manipulate sources anyway you like though. Be it with a desktop file manager or a terminal 
command line. After you made your changes, you run `mulle-sde reflect` to reflect your changes
back into `CMakeListst.txt` (indirectly via `cmake/_Headers.cmake` and `cmake/_Sources.cmake`). 
You can check if your files will be found with `mulle-sde list --files`.


{% include tip.html content="If you look at the default project settings with `mulle-sde environment list`
you will see these relevant entries for source files:

```
PROJECT_SOURCE_DIR=\"src\"
MULLE_MATCH_FILENAMES=\"config:*.h:*.inc:*.c:CMakeLists.txt:*.cmake:*.m:*.aam\"
MULLE_MATCH_IGNORE_PATH=
MULLE_MATCH_PATH=\".mulle/etc/sourcetree/config:${PROJECT_SOURCE_DIR}:CMakeLists.txt:cmake\"
```

Files that match any of the wildcards given in `MULLE_MATCH_FILENAMES` are
considered interesting *matchable* files. Changes in any of those files
should trigger a rebuilt. These files are searched for in the places given by
`MULLE_MATCH_PATH`, which is a combination of files and directories of your
project. %}


## Setting up a complex project for the modern workflow

As a golden rule of the modern workflow: do not create projects
with multiple targets. If you have a library and an executable, make it two
separate projects.

You can setup each type of project easily with:

```
mulle-sde init -m foundation/objc-developer -d mylib library
mulle-sde init -m foundation/objc-developer -d myexe executable
```

Your project layout would then look like this:

```
myproject
├── myexe
└── mylib
```

If you want to use the library with your executable, you add the library as a
dependency to the executable:

```
mulle-sde dependency add --objc --github "${GITHUB_USERNAME:-nobody}" mylib
```

The `GITHUB_USERNAME` can be totally fake, but it is needed to create a URL
for the library project, just in case you want to distribute your executable
later.


{% include tip.html content="Since `mylib` is a sibling of `myexe` it
will be easily found. If you place it somewhere else, you need to add it's
parent directory to the search-path variable `MULLE_FETCH_SEARCH_PATH`.
E.g. `mylib` is `/home/wherever/src/mylib` then modify the search-path with `mulle-sde environment set MULLE_FETCH_SEARCH_PATH '/home/wherever/src:${MULLE_FETCH_SEARCH_PATH}'`" %}

With `mulle-sde dependency list` or the more low-level `mulle-sourcetree list -ll`
you can see the dependency structure of your project.

At this point you're done.

{% include note.html content="You do not have to `#import` anything or add link
statements to your `CMakeLists.txt`, it's all done for you with
`mulle-sde reflect`, which you run in both projects." %}

## Next

Add a third party [dependency](mydoc_pnp_dependency.html) to your project.
