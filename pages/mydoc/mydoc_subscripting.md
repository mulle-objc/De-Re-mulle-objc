---
title: subscripting
keywords: class
last_updated: March 26, 2019
tags: [runtime]
summary: ""
permalink: mydoc_subscripting.html
folder: mydoc
---

## Translate array[ 0]

Use `[array objectAtIndex:0]` or the MulleObjC shortcut `[array :0]`. The latter
will make your code incompatible with other runtimes though.

## Translate dictionary[ @"key"]

Use `[dictionary objectForKey:@"key"]` or the MulleObjC shortcut `[dictionary :@"key"]`.
The latter will make your code incompatible with other runtimes though.