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
dependencies, which are more libraries. The dependencies are searched for in
the cmake files.

In a real life example [mulle-sprintf](/github.com/mulle-core/mulle-sprintf)
depends on:

```
mulle-buffer
mulle-utf
mulle-vararg
mulle-thread

```

As each dependency may have more dependencies, this expands to:

```
mulle-buffer
   mulle-allocator
   mulle-c11
   mulle-data
mulle-utf
mulle-vararg
mulle-thread
```

All these libraries must be linked to the executable. mulle-sde and cmake do
this for you automatically. If you do not want to use mulle-sde you need
to take care of all the loose ends yourself.

## Startup libraries

For Objective-C executables we also need to add a so called startup library,
that initialized the runtime. In case of the Foundation this will be
the `Foundation-startup`.

