---
title: mulle-objc Tools
keywords: class
last_updated: March 26, 2019
tags: [tools]
summary: ""
permalink: mydoc_tools.html
folder: mydoc
---

## mulle-objc-list/mulle-objc-lista

**mulle-objc-list** generates CSV style information from dynamic libraries,
that contain mulle-objc code. You can list the contained classes, methods and
properties. It's the backbone of the mulle-objc tool set.

**mulle-objc-lista** is the variant that handles static libraries.

See [mulle-objc-runtime](//github.com/mulle-objc/mulle-objc-runtime) for more
details.


## mulle-objc-uniqueid

Generates the `@selector()` hash value from a string. This can be useful when
writing C code, that calls Objective-C.

```
$ mulle-objc-uniqueid alloc
ab1bb16b
```

```
mulle_objc_object_call( self, 0xab1bb16b, nil);
```

See [mulle-objc-runtime](//github.com/mulle-objc/mulle-objc-runtime) for more
details.


## mulle-objc-loader-tool

Generates the required `MulleObjCLoader` category files for a library.
This tool is used in the [modern workflow](mydoc_modern) to generate the
proper dependency information.

See [mulle-objc-list](//github.com/mulle-objc/mulle-objc-list) for more
details.


## mulle-objc-signature

Separates an '@encode()' Objective-C type into constituents, separated by ';'.
This can be useful for creating inspection tools.

```
$ mulle-objc-uniqueid alloc ^v@:@"NSString"
^v;@;:;@"NSString"
```
See [mulle-objc-runtime](//github.com/mulle-objc/mulle-objc-runtime) for more
details.


## mulle-objc-printline

A little utility to fake a "class-coverage.csv" entry.

```
$ mulle-objc-printline --method -foo --category Foo Bar
bbc7dbad;Bar;c7e16770;Foo;9f37ed7a;-foo
```
See [Coverage](mydoc_coverage.html) for more details about mulle-objc
coverage information.


## mulle-objc-searchid

Grep through libraries to find the matching string for a selector, classid,
protocol et.c.  This can be useful when debugging optimized code.

```
$ mulle-objc-searchid ab1bb16b
@selector( alloc) is ab1bb16b
```

See [mulle-objc-list](//github.com/mulle-objc/mulle-objc-list) for more
details.


## mulle-objc-unarchive

Used by the library optimization process, that unpacks and repacks static
libraries to only contain required classes and categories.


See [mulle-objc-list](//github.com/mulle-objc/mulle-objc-list) for more
details.


## mulle-objc-uncovered-methods

Creates a list of methods not being messaged during a programs run. This can
be useful for finding missing tests.

See [Coverage](mydoc_coverage.html) for more details about mulle-objc coverage information.


## Next

Check out the [legacy workflow](mydoc_legacy.html) for an alternative to the
modern workflow.