---
title: Porting @property
keywords: property class
last_updated: March 26, 2019
tags: [runtime]
permalink: mydoc_property.html
folder: mydoc
---

Porting properties in a fashion that works in ARC code and in MulleObjC is
tricky. It is best if you can restrict yourself to **assign**, **copy** and **retain**.



## Property deallocation

{% include note.html content="This is a rare case, where MulleObjC is compatible with ARC, but incompatible with MMR." %}

In Apple ARC, properties are automatically cleared during `-dealloc`. In Apple Manual Retain-Release Mode (MRR)
you have to do it yourself during `-dealloc`.

In MulleObjC all properties that reference objects or pointers are cleared during `-finalize` by
setting them to **0**. 

**readonly** properties - they have no setter - are not cleared. But in mulle-objc _they are backed by an **ivar**_.
It is open to discussion if you want to release them in `-dealloc` for compatibility or use `-finalize` to break
possible retain cycles.

Here is how to write `-dealloc` for compatiblity with MMR (also see [ARC Porting tips](mydoc_arc.html)):

```
#if __has_feature(objc_arc) || defined( __MULLE_OBJC__)
# define PROPERTY_RELEASE( p)  
#else
# define PROPERTY_RELEASE( p)  [_p release]
#endif
#if __has_feature(objc_arc)
# define SUPER_DEALLOC()  
#else
# define SUPER_DEALLOC( p)  [super dealloc]
#endif

- (void) dealloc
{
    PROPERTY_RELEASE( a)
    PROPERTY_RELEASE( b)
    PROPERTY_RELEASE( c)
    SUPER_DEALLOC()
}

```

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

Remove the property. Use `static` variables in your `@implementation`
then write and declare `+` accessors for them.

{% include note.html content="`class` is likely to make a comeback in a future version." %}

