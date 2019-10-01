---
title: Linking
keywords: class
last_updated: March 26, 2019
tags: [runtime, os]
summary: ""
permalink: mydoc_linking.html
folder: mydoc
---

Explains the various linking styles. To recap, each library has a set of
dependencies, which are more libraries. The dependencies are listed in
searched for in the cmake files.

So assuming you have mulle-objc-runtime, you will find its dependencies are:

```
mulle-concurrent
mulle-vararg
mulle-stacktrace
```

As each dependency may have more dependencies, this expands to:

```
mulle-concurrent
 mulle-aba
  mulle-allocator
   mulle-c11
  mulle-thread
   mintomic
   pthread
mulle-vararg
 mulle-c11
mulle-stacktrace
 mulle-dlfcn
```

All these libraries must be linked to an executable.

But the mulle-objc-runtime is not complete for an executable to run. It also
needs a startup library, that is statically linked.
This is mulle-objc-runtime-startup.

It also has some dependencies:

```
mulle-atinit
 mulle-thread
  mulle-c11
  mintomic
  pthread
 mulle-dlfcn
  dlfcn
  dl
  psapi
mulle-atexit
 mulle-thread
mulle-dlfcn
```



## Modern

mulle-objc-runtime +
mulle-objc-runtime dependencies +
mulle-objc-runtime-startup +
mulle-objc-runtime dependencies +
executable                               -> executable


Modern is all libraries statically linked into an executable. This is the
easiest scenario. Only the order of the linked libraries may be important.

+ executable is one file
+ optimization of actually linked code is possible
- many executables (e.g. tests) waste space


## Legacy

mulle-objc-runtime +
mulle-objc-runtime dependencies +
mulle-objc-runtime-startup +
mulle-objc-runtime dependencies          -> standalone (dynamic)

In legacy everything but the executable is linked together as one shared
library. This library then is linked against the executable. Again this is easy
to create, if one observers the proper linked or compiler flags (-fPIC).


+ "user" just needs to link one library (no order problems)
- executable and shared library must be distributed as two files or packages
- impossible to optimize unused code away
- probably somewhat slower


## Test

mulle-objc-runtime                       -> dynamic
mulle-objc-runtime dependencies          -> dynamic

mulle-objc-runtime-startup               -> static
mulle-objc-runtime-startup dependencies  -> static


+ executables take up little space
- tricky to orchestrate right
- tricky to build right
- impossible to optimize unused code away
- slower

Everything except the startup is created as dynamic libraries.
A test executable links against all. The challenge is here, that
static and dynamic libraries must not overlap. (e.g. dlfcn)



