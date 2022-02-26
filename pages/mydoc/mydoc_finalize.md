---
title: -finalize
keywords: object
last_updated: February 26, 2022
tags: [runtime, 8.0.0]
summary:
permalink: mydoc_finalize.html
folder: mydoc
---


## `-finalize` runs automatically before `-dealloc`

When the `-retainCount` is decremented to zero via `-release`, an object gets
the `-finalize` message.

![](images/object-lifetime.svg)

If the retainCount remains unchanged throughout `-finalize`, then `-dealloc`
is called afterwards.

During `-finalize` all **@properties** with pointers (e.g. `void *`) or objects (e.g. `NSArray *`) will be cleared.

So `-finalize` is used to free resources and cut links to other objects.
Objects that are cleared by `-finalize`  will be released with  `-autorelease`
and not with `-release`.

`-dealloc` will ideally at most contain `-release` calls and `[super dealloc]`.
Anything else can be done in `-finalize`.

So why not do everything in `-dealloc` ?



## `-mullePerformFinalize` runs `-finalize` on demand

You can use `-mullePerformFinalize` to finalize an object “manually”, but you
shouldn't call `-dealloc` manually on a reference counted object.

![](images/object-finalize.svg)

The finalization can happen in the "middle of the lifetime" of the object.
And it is guaranteed that `-finalize` is only called once.

{% include note.html content="Never call `-finalize` directly, always use `-performFinalize`." %}

A finalized object is still useable in the object hierarchy,
but it is not active anymore. An example, where this is useful, is a window
controller, where the window close button has been clicked. It may still
redraw, but it doesn’t react to any event actions any more.


## Your `-finalize` must call `[super finalize]` 

If you write a `-finalize` method call `[super finalize]` so that NSObject can
clean up properties.


## Write `-finalize/-dealloc` portably 

If you use `-finalize`, you will be incompatible with non-ARC Apple. This can be
remedied, by structuring your `-finalize/-dealloc` code like this:


```
- (void) _finalize
{
}

- (void) finalize
{
  [self _finalize];

   [super finalize];
}

- (void) dealloc
{
#ifndef __MULLE_OBJC__
   [self _finalize];
#endif
   [super dealloc];
}
```

## Caveat

`-finalize` is single-threaded, just like `-init` and `-dealloc` when called
during `release`. When you invoke `-mullePerformFinalize` it can only be
guaranteed, that no other thread will be executing `-finalize` (ever). But it
is _not guaranteed_ that no other thread is accessing the object. That's
different to `-dealloc`, where the guarantee is that no other thread will
ever call this object again.

{% include note.html content="What's the deal with the `clearer` in `struct _mulle_objc_property` ?
It's an optimization so that the clearer code doesn't need to run for objects, that have no usefully clearable properties."
%}
