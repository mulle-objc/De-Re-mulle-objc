---
title: Multiple Targets in the Modern Workflow
keywords: class
last_updated: Apr 4, 2020
tags: [tools modern]
summary: ""
permalink: mydoc_modern_complex.html
folder: mydoc
---


## Setting up a complex project for the modern workflow

A golden rule of the modern workflow is: do not create projects
with multiple targets. If you have a library and an executable, make it two
separate projects.

You can setup and link each project easily with:

``` console
mulle-sde init -m foundation/objc-developer -d mylib library
mulle-sde init -m foundation/objc-developer -d myexe executable
```

Your project layout would then look like this:

```
myproject
├── myexe
└── mylib
```

As you want to use the library with your executable, you add the library as a
dependency to the executable:

``` console
cd myexe
mulle-sde dependency add --objc --github "${GITHUB_USERNAME:-nobody}" mylib
```

The `GITHUB_USERNAME` can be fake, but it is needed to create a URL
for the library project, just in case you want to distribute your executable
later. It can also be changed later.


{% include tip.html content="Since `mylib` is a sibling of `myexe` it
will be easily found. If you place it somewhere else, you need to add it's
parent directory to the search-path variable `MULLE_FETCH_SEARCH_PATH`.
E.g. `mylib` is `/home/wherever/src/mylib` then modify the search-path with `mulle-sde environment set MULLE_FETCH_SEARCH_PATH '/home/wherever/src:${MULLE_FETCH_SEARCH_PATH}'`" %}

With `mulle-sde dependency list` or the more low-level `mulle-sourcetree list -ll`
you can see the dependency structure of your project.

```
address             marks                                           aliases  include
-------             -----                                           -------  -------
Foundation          no-singlephase
Foundation-startup  no-dynamic-link,no-header,no-intermediate-link
mylib               no-singlephase
```

At this point you're ready to craft again.

```
mulle-sde craft
```

And there you are.

{% include note.html content="You do not have to `#import` anything or add link
statements to your `CMakeLists.txt`, it's all done for you with
`mulle-sde reflect`." %}

## Next

Add a third party [dependency](mydoc_pnp_dependency.html) to your project.
