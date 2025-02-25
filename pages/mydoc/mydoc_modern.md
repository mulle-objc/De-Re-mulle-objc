---
title: Project Setup
keywords: class
last_updated: January 23, 2025
tags: [tools modern]
summary: ""
permalink: mydoc_modern.html
folder: mydoc
---

## Install mulle-objc

This guide doesn't have detailed installation instructions for
**mulle-objc**.

Read the instructions on
[foundation-developer](https://github.com/MulleFoundation/foundation-developer)
and follow them.

Afterwards you should have **mulle-clang** and **mulle-sde** in your PATH.

``` console
mulle-clang --version
mulle-sde --version
```

and you should all be setup for coding.


## Foundation vs mulle-objc

There are two starting points. If you want a full class system with strings,
containers and OS support, you will want to base your code on the **Foundation**.

If you just want to play with a minimal runtime, base your code on **MulleObjC**. This is the best choice for new platforms.
Then, instead of `-m foundation/objc-developer`, use `-m mulle-objc/objc-developer`

mulle-sde is powerful enough to warrant its own guide [De Re mulle-sde](//www.mulle-kybernetik.com/de-re-mulle-sde/). But to get you moving quickly,
lets set up a demo project right now:


## Example "Hello World" project

### Create

Generate a new executable project with:

``` console
mulle-sde init -m foundation/objc-developer -d hello-world executable
```

Your project filesystem structure on your file system will look like the
following `tree` output. You can see the demo source in `src/main.m` along
with more generated content:

<pre><font color="#3465A4"><b>hello-world</b></font>
├── <font color="#3465A4"><b><i>.mulle</i></b></font>
├── CMakeLists.txt
├── README.md
├── <font color="#3465A4"><b>cmake</b></font>
│   ├── <font color="#3465A4"><b>reflect</b></font>
│   │   ├── _Dependencies.cmake
│   │   ├── _Headers.cmake
│   │   ├── _Libraries.cmake
│   │   ├── README.md
│   │   └── _Sources.cmake
│   └── <font color="#3465A4"><b>share</b></font>
│       ├── AAMSupportObjC.cmake
│       ├── ...
│       └── UnwantedWarningsC.cmake
└── <font color="#3465A4"><b>src</b></font>
    ├── import.h
    ├── import-private.h
    ├── main.m
    ├── <font color="#3465A4"><b><i>reflect</i></b></font>
    │   ├── <i>_hello-world-import.h</i>
    │   ├── <i>_hello-world-import-private.h</i>
    │   └── <i>objc-loader.inc</i>
    └── version.h
</pre>


`CMakeLists.txt` is your main [cmake](//cmake.org) project file. [cmake](//cmake.org) is
the default mulle-sde build system, but it can be substituted with another,
if so desired.

The source is in the `src` folder. Source will be found in `src` or in any of the
its subfolders. A source file anywhere else will not be picked up by
`mulle-sde reflect` and will therefore not be built. (You can change the
default behaviour later)


#### Special folders

* The `.mulle` folder is used for project management. You usually edit its
contents via mulle-sde commands and not directly.
* `reflect` folders will be recreated whenever the `mulle-sde reflect`
command is run, so don't edit them.
* `share` folders will be overwritten when the `mulle-sde upgrade`
command is run, so don't edit those either.
* `var` folders (found inside `.mulle`) can change any time a mulle-sde command is run, so don't
touch them.

### Run

You are ready to craft your executable and run it. The very first `craft`
command will be quite slow, as mulle-sde will setup a virtual environment
for your project. This is somewhat akin to creating a *docker* container. 
mulle-sde needs to do it once:

``` console
cd hello-world
mulle-sde craft
mulle-sde run
```


### Edit

Consult the [mulle-objc Development with IDEs](https://www.mulle-kybernetik.com/mulle-objc-ide/)
guide to set up an editor or IDE of your preference.

You can then edit your project with:

``` objc
mulle-sde edit
```

### Add

Source files live in the `src` folder of your project.

The most convenient way to add files is with the `mulle-sde add` command, as
this gives you preconfigured implementation and interface files for a new class
for instance.
If you use a `+` in your filename, you will get files for a category.

``` console
mulle-sde add src/Foo.m
mulle-sde add src/Foo+Stuff.m
```

The add command will automatically run `mulle-sde reflect`, so that is all
there is to it. You can now craft your project with `mulle-sde craft` again.

You can use the `-t` option to specify the exact type of Objective-C
construct you want to generate (e.g. `mulle-sde add -t protocolclass src/Boo.m`).
Out of the box, mulle-objc provides these three types:

| Type                 | Description
|----------------------|-------------------
| `category`           | Category `.m` and `.h` file
| `protocolclass`      | Protocolclass `.m` and `.h` file
| `file`               | Class `.m` and `.h` file


### Rename and Remove

You can move, rename or remove sources anyway you like with whatever
tool you like. After you made your
changes, run `mulle-sde reflect` to reflect your changes back into
`CMakeLists.txt` (indirectly via `cmake/_Headers.cmake` and
`cmake/_Sources.cmake`).

``` console
mkdir -p src/foo/wherever
mv src/Foo.* src/foo/wherever
mulle-sde reflect
mulle-sde craft
```

You can check that your files are found with `mulle-sde files`. You can
see how the proper include paths are generated by looking at the
`INCLUDE_DIRS` variable in `cmake/reflect/_Headers.cmake`.


### Settings

You can look at the project settings with `mulle-sde env`.
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

A more detailed look at how a mulle-sde project deals with
[header](mydoc_pnp_source.html) sources.
