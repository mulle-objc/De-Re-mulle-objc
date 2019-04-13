---
title: MulleObjC Caveats
keywords: class
last_updated: March 26, 2019
tags: [runtime]
permalink: mydoc_caveats.html
folder: mydoc
---

There are some significant differences that come into play, when you want
to do "tricky" stuff with Objective-C. 

## Allocation

The example implementation of NSObject:

```
+ (instancetype) alloc
{
   return( NSAllocateObject( self, 0, NULL));
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( NSAllocateObject( self, 0, zone));
}


+ (instancetype) new
{
   return( [NSAllocateObject( self, 0, NULL) init]);
}
```


### `+alloc`

If  you are implementing your own `+alloc` routine you should also implement `+new`.


# `+new`

`+new` is shorter than writing `+alloc` and `-init` and in MulleObjC `+new`
will not call `+alloc`. Users can rely on `-init` being called by `+new` though.


### `+allocWithZone:`

The  *legacy* allocation method is `+allocWithZone:`, but you 
should use `+alloc` in MulleObjC. For compatibility with legacy code
also implement `+allocWithZone:` the same as you implemented `+alloc`.
You may safely ignore the `zone` pointer.

Do not call `+alloc` from `+allocWithZone:` or vice versa.


## Retain Counting

Do not override `-retain`, `-release` except for debugging purposes. In the highest 
compiler optimization level these methods will not be used.



