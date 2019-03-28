---
title: Porting @property
keywords: property class
last_updated: March 26, 2019
tags: [runtime]
permalink: mydoc_property.html
folder: mydoc
---

Porting properties in a fashion that works in ARC code and in MulleObjC is
tricky. It is best if you can restrict yourself to
**assign**, **copy** and **retain**.


## Missing Attributes

### atomic

Yup it's gone. Use locking or the atomic operations provided by
[mulle-thread](//github.com/mulle-concurrent/mulle-thread).


### weak

Use **assign** instead.

{% include note.html content="Use C containers to manage weak references
instead. They won't *magically* cleanup though." %}

### strong

When declaring a property use **copy** or **retain**. You usually
use **copy** for `NSValue`, `NSDate`, `NSNumber` and `NSString` arguments,
and **retain** for everything else.

### nullable

One of the strong points of Objective-C is its gracious handling of
`nil` values, which simplifies coding a lot. Remember that messaging `nil`
also produces `nil`. With the introduction of `nonnull` `nullable` was
also introduced. It is superflous.

You can easily get rid of `nullable` compile errors with:

```
#define nullable
```

{% include note.html content="Tedious checks for `nil` means you are optimizing
your code for the error case. Use **nonnull** sparingly. If a `nil` parameter
has no ill effect, don't mark the code **nonnull**." %}

### unsafe_unretained

Use **assign** instead.


### class

Remove the property. Use `static` variables in your @implementation
then write and declare `+` accessors for them.


