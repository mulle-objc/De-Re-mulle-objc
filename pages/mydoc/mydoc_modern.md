---
title: Modern Workflow
keywords: class
last_updated: Apr 4, 2020
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

If you just want to play with a minimal runtime, base your code on **MulleObjC**.
Then, instead of `-m foundation/objc-developer`, use `-m mulle-objc/objc-developer`


## Example "Hello World" project

### Create

Generate a new executable project with:

``` console
mulle-sde init -m foundation/objc-developer -d hello-world executable
```

Your project filesystem structure on your file system will look like the
following `tree` output. You can see the demo source in `src/main.m` along
with more generated content:

<pre>
hello-world
├<font color="#888">── .mulle                       // mulle-sde configuration</font>
│<font color="#888">   └── ...</font>
├── cmake
│   ├── DependenciesAndLibraries.cmake
│   ├── <i>_Dependencies.cmake</i>      // reflect
│   ├── Headers.cmake
│   ├── <i>_Headers.cmake</i>           // reflect
│   ├── <i>_Libraries.cmake</i>         // reflect
│   ├<font color="#888">── share                    // mulle-sde cmake files</font>
│   │<font color="#888">   └── ...</font>
│   ├── <i>_Sources.cmake</i>           // reflect
│   └── Sources.cmake
├── CMakeLists.txt               // cmake project
├── README.md
└── src                          // source directory
    ├── import.h
    ├── import-private.h
    ├── <b>main.m</b>
    ├── <i>_myexe-import.h</i>          // reflect
    ├── <i>_myexe-import-private.h</i>  // reflect
    └── version.h
</pre>

Files marked with `reflect` will be recreated by mulle-sde on demand - more
specifically whenever `mulle-sde reflect` is run, so don't edit them.

{% include tip.html content="All folders named `share` are considered upgradable by
mulle-sde. They will be wiped and recreated when you do a `mulle-sde upgrade` sometime
into the future. You should not edit their contents. Similiarly folders called `var`
are used for temporary content and may be wiped and recreated by commands.
Files with an underscore prefix will be recreated by the next run of
`mulle-sde reflect`" %}

### Run

You are ready to craft your executable and run it. The very first `craft`
command will be quite slow, as mulle-sde will setup a virtual environment
for your project. This is somewhat akin to creating a `docker container`. But
it will only do this once:

``` console
cd hello-world
mulle-sde craft
./kitchen/Debug/hello-world
```


### Edit

I suggest [Sublime Text](https://www.sublimetext.com/) or
[VSCode](https://code.visualstudio.com/) in the beginning.
Both run on all major platforms (like mulle-objc is supposed to) and there
are extensions for both. The extensions do quite a bit of otherwise tedious
setup:

```
mulle-sde extension add sublime-text # will create hello-world.sublime-project
mulle-sde extension add vscode       # will create hello-world.code-workspace
```

### Add

Source files live in the `src` folder of your project (can be changed with `PROJECT_SOURCE_DIR`).

The most convenient way to add files is with the `mulle-sde add` command, as
this gives you preconfigured implementation and interface files for a new class.
If you use a `+` in your filename, you will get files for category.

``` console
mulle-sde add src/Foo.m
mulle-sde add src/Foo+Stuff.m
```
The add command will automatically run `mulle-sde reflect`, so that is all
to it. You can now craft your project with `mulle-sde craft` again.

You can use the `-t` option to specify the exact filetype you want to
generate (e.g. `mulle-sde add -t protocolclass src/Boo.m`).
Out of the box, mulle-objc provides these three types:


Type                 | Description
---------------------|-------------------
`category`           | Category `.m` and `.h` file
`protocolclass`      | Protocolclass `.m` and `.h` file
`file`               | Class `.m` and `.h` file


### Rename and Remove

You can move, rename or remove sources anyway you like. After you made your
changes, run `mulle-sde reflect` to reflect your changes back into
`CMakeLists.txt` (indirectly via `cmake/_Headers.cmake` and
`cmake/_Sources.cmake`).

``` console
mkdir -p src/foo/wherever
mv src/Foo.* src/foo/wherever
mulle-sde reflect
mulle-sde craft
```

You can check if your files are found with `mulle-sde list --files`. You can
see how the proper include paths are generated by looking at the
`INCLUDE_DIRS` variable in `cmake/_Headers.cmake`.


### Settings

You can look at the project settings with `mulle-sde environment list`.
You will see these relevant entries for source files:

``` console
PROJECT_SOURCE_DIR="src"
MULLE_MATCH_FILENAMES="config:*.h:*.inc:*.c:CMakeLists.txt:*.cmake:*.m:*.aam"
MULLE_MATCH_IGNORE_PATH=
MULLE_MATCH_PATH=".mulle/etc/sourcetree/config:${PROJECT_SOURCE_DIR}:CMakeLists.txt:cmake"
```

Files that match any of the wildcards given in `MULLE_MATCH_FILENAMES` are
considered interesting, *matchable* files. Changes in any of those files
should trigger a recraft. `MULLE_MATCH_PATH` contains the combination of files
and directories that will be searched. Conversely files, will be ignored that
are found in `MULLE_MATCH_PATH` but that are part of `MULLE_MATCH_IGNORE_PATH`.


## Next

Setup [multiple targets](mydoc_modern_complex.html) for your project.
