---
title: Memory managment rules
keywords: class
last_updated: March 26, 2019
tags: [runtime,memory]
summary: ""
permalink: mydoc_memory.html
folder: mydoc
---

Here are the rules for memory management in mulle-objc.

{% include note.html contents="At a later time, the compiler may enforce some of these rules." %}


## Use of `-release`

`-release` should only be used in the following special methods:

* `-init` methods
* `-dealloc`
* `+load` and `+unload`
* `+initialize` and `+deinitialize`

`-release` may be used in circumstances like the following, if you are certain
that the intervening code can not raise an exception. This is still
not recommended though:

``` objc
  p = [Foo new];
  [array addObject:p];
  [p release];
```

## Use of a variable after release

You should not use an instance's address after it has been released.

E.g. this is not good code:

``` objc
  p = [Foo new];
  [array addObject:p];
  q = p;  // alias to trick a future compiler
  [p release];
  return( q);
```

## Use of `-autorelease`

`-autorelease` is the method to relinquish ownership of an object. Use of `-autorelease` is critical
to maintain temporal consistency and ownership transfer.

Use `-autorelease` everywhere, also in `-finalize`, except where use of `-release` is indicated.

`-autorelease` immediately after `+new` or `+alloc`/`-init` with `-autorelease`. This will be
crucial for leak checking test code.

-----

Also read [ARC porting tips](mydoc_arc.html) on how to write code, that works well on
all Objective-C platforms.

