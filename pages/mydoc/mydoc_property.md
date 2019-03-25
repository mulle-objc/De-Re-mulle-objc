---
title: Properties
keywords: property class
last_updated: March 26, 2019
tags: [runtime]
summary: "Properties in MulleObjC"
sidebar: mydoc_sidebar
permalink: mydoc_property.html
folder: mydoc
---

## NOTHING HERE YET

## atomic

Yup it's gone. Use locking or the atomic operations provided by
[mulle-thread](//github.com/mulle-concurrent/mulle-thread).


## weak

When declaring a `@property` use `assign`.

> Use C containers to manage weak references instead. They won't "magically" cleanup
though.

## strong

When declaring a `@property` use `copy` or `retain`. You usually
use `copy` for `NSValue`, `NSDate`, `NSNumber` and `NSString` arguments,
and `retain` for everything else.

