---
title: Porting Xcode projects
keywords: class
last_updated: May 31, 2019
tags: [tools porting xcode]
summary: ""
permalink: mydoc_xcodeproj.html
folder: mydoc
---

As **mulle-objc** evolves, more and more Xcode projects will be portable
without effort. For now Foundation based Tool and Library targets are
the candidates for porting.



## mulle-xcode-to-cmake

Getting an existing Xcode project to run with **mulle-objc** can be very easy
with [mulle-xcode-to-cmake](//github.com/mulle-nat/mulle-xcode-to-cmake).
Assuming  that your Xcode project file is named "project.xcodeproj", these
steps may already be sufficient:


```
mulle-xcode-to-cmake export project.xcodeproj > CMakeLists.txt
mulle-sde init -m foundation/objc-porter executable
mulle-sde craft
```

To install:


```
mulle-sde craft craftorder
mulle-sde run mulle-make install --prefix /tmp/whereever
```


## Converting to the modern workflow

If your project contains one or many libraries, it is best to split them
up into multiple projects.

Replace the *objc-porter* environment with the *objc-developer* environment:

```
rm -rf .mulle
mulle-sde init -m foundation/objc-developer executable
```

Now read up how the setup the [modern workflow](mydoc_modern.html).
