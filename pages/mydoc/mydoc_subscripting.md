---
title: subscripting
keywords: class
last_updated: March 26, 2019
tags: [runtime]
summary: ""
permalink: mydoc_subscripting.html
folder: mydoc
---

The use of [] to index into an Objective-C array like into a C array is known
as "subscripting". It will never be supported by **mulle-objc**, because it
introduces an un-C like ambiguity. This also precludes subscripting for
dictionaries.

## Translate array[ 0]

Use `[array objectAtIndex:0]` or the mulle-objc shortcut `[array :0]`. The latter
will make your code incompatible with other runtimes though.

## Translate dictionary[ @"key"]

Use `[dictionary objectForKey:@"key"]` or the mulle-objc shortcut `[dictionary :@"key"]`.
The latter will make your code incompatible with other runtimes though.