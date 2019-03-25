---
title: nszone
keywords: class
last_updated: March 26, 2019
tags: [runtime]
summary: ""
sidebar: mydoc_sidebar
permalink: mydoc_nszone.html
folder: mydoc
---

Zones are dead. Do not use the `withZone:` methods anymore.

MulleObjC will work well enough if you use them, but they are just superflous.
Incidentally I don't think Apple Objective-C uses them either anymore.

### Compiler transforms -zone calls

With that being said, the **mulle-objc** compiler will transform any
call to `-zone` into `NULL`.

