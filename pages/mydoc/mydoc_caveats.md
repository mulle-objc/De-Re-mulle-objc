---
title: mulle-objc Caveats
keywords: class
last_updated: March 26, 2019
tags: [runtime]
permalink: mydoc_caveats.html
folder: mydoc
---

There are some significant differences that come into play, when you want
to do "tricky" stuff with Objective-C.

## Allocation

### Allocation methods

The example implementation of NSObject:

``` objc
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


#### `+alloc`

If  you are implementing your own `+alloc` routine you should also implement `+new`.


#### `+new`

`+new` is shorter than writing `+alloc` and `-init` and in mulle-objc `+new`
will not call `+alloc`. Users can rely on `-init` being called by `+new` though.


#### `+allocWithZone:`

The  *legacy* allocation method is `+allocWithZone:`, but you
should use `+alloc` in mulle-objc. For compatibility with legacy code
also implement `+allocWithZone:` the same as you implemented `+alloc`.
You may safely ignore the `zone` pointer.

Do not call `+alloc` from `+allocWithZone:` or vice versa.


### Extra bytes and `class_getInstanceSize`

Allocating extra bytes at the end of an instance can be done with `NSAllocateObject` as usual.
You should be aware, that for compatibility reasons `class_getInstanceSize` will return
the number of bytes that are required to allocate an instance. This is *not* the same as
the offset to the extra bytes.

```
static inline void   *getFooExtraBytes( Foo *self)
{
   size_t    size;

   size = class_getInstanceSize( [self class]);
#ifdef __MULLE_OBJC__
   size -= sizeof( struct _mulle_objc_objectheader);
#endif
   return( (void *) &((char *) self)[ size]);
}
```


## Retain Counting

Do not override `-retain`, `-release` except for debugging purposes. In the highest
compiler optimization level these methods will not be used.



