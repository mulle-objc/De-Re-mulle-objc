---
title: Modern Workflow
keywords: class
last_updated: March 26, 2019
tags: [tools modern]
summary: ""
permalink: mydoc_modern.html
folder: mydoc
---

Objective-C is an [Object Oriented Programming Language](https://en.wikipedia.org/wiki/Object-oriented_programming).
With that comes the expectation of a plug-n-play programming environment,
where classes and categoroie can be added and removed, without having to
edit part of application. This expectation was largely never fulfilled in,
due to deficiencies with the compilation tools, the Objective-C runtime and
the general way headers are imported.

**mulle-objc** wants to achieve such a plug-n-play environment, and for that the
modern workflow has been created. First of all it is static library based.

The immediate advantages of that approach are:

* static linking works on platforms that do not support dynamic libraries
* static linking can be optimized to remove unused classes and categories
* static linking produces executables that are easier to install and deploy


## Setting up a project for the modern workflow

As a golden rule of the modern workflow do not create projects
with multiple targets. If you have a library and an executable, make it two
separate projects.

You can setup each type of project easily with:

```
mulle-sde init -m foundation/objc-developer -d mylib library
mulle-sde init -m foundation/objc-developer -d myexe executable
```

Your project layout would be then like this:

```
src
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
`mulle-sde update`, which you run in both projects." %}

## Writing classes that benefit from the modern workflow

It is not only that libraries are plug-n-play in **mulle-objc**. It is also
a goal, that source-files are motile. They should be easily moved between
various libraries without the need to edit anything. Read [The beauty of generic header-names](https://www.mulle-kybernetik.com/weblog/2019/beauty_of_generic_headers.html) for more on that.

In general write your `@interface` headerfiles like this:

```
#import "import.h"


@interface Foo : NSObject
@end
```

And your implementations like so:

```
#import "Foo.h"

#import "import-private.h"

@implementation Foo
@end
```

and your class will partake in the "modern workflow".

{% include note.html content="Avoid referencing dependency headers in your source files directly. Use the generic `import.h` and `import-private.h` headers instead" %}


## Adding files to or removing files from a project

If you look at the default project settings with `mulle-sde environment list`
you will find amongst those these relevant entries:

```
PROJECT_SOURCE_DIR="src"
MULLE_MATCH_FILENAMES="config:*.h:*.inc:*.c:CMakeLists.txt:*.cmake:*.m:*.aam"
MULLE_MATCH_IGNORE_PATH=
MULLE_MATCH_PATH=".mulle/etc/sourcetree/config:${PROJECT_SOURCE_DIR}:CMakeLists.txt:cmake"
```

Files that match any of the wildcards given in `MULLE_MATCH_FILENAMES` are
considered interesting *matchable* files. Changes in any of those files
should trigger a rebuilt. These files are searched for in the places given by
`MULLE_MATCH_PATH`, which is a combination of files and directories of your
project.

Knowing this, it is now clear that sourcefiles should be placed into
`${PROJECT_SOURCE_DIR}` which is `src`. These files will be found by
`mulle-sde update` and incorporated into the `CMakeLists.txt`. You can check
this with `mulle-sde list`.

{% include note.html content="You do not need to edit `CMakeLists.txt` when
adding or removing files from your project." %}


