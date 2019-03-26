---
title: Properties
keywords: property class
last_updated: March 26, 2019
tags: [runtime]
summary: "Properties in MulleObjC"
permalink: mydoc_property.html
folder: mydoc
---

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

## nullable

One of the strong points of Objective-C is its gracious handling of
`nil` values, which simplifies coding a lot. Remember that messaging `nil`
also produces `nil`. With the introduction of `nonnullable` `nullable` was
also introduced. It is superflous.

You can easily get rid of `nullable` compile errors with:

```
#define nullable
```

### Tip

Tedious checks for `nil` means you are optimizing your code for the error case.
Use `non-nullable` sparingly. If a `nil` parameter has no ill effect,
don't mark the code `non-nullable`.
