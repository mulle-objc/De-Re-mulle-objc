---
title: -finalize
keywords: object
last_updated: April 10, 2019
tags: [runtime, 8.0.0]
summary:
permalink: mydoc_finalize.html
folder: mydoc
---

## `-finalize` runs automatically before dealloc

When the `-retainCount` is decremented to zero via `-release`, an object gets the `-finalize` message first before `-dealloc`.
If the retainCount remains unchanged throughout `-finalize`, then `-dealloc` is called. 
It is guaranteed that `-finalize` is only called once.

During `-finalize` all **@properties** with pointers (e.g. `void *`) or objects (e.g. `NSArray *`) will be cleared.

So `-finalize` is used to free resources and cut links to other objects. Objects that are cleared by `-finalize` 
will be released with  `-autorelease` and not with `-release`.

`-dealloc` will ideally at most contain `-release` calls and `[super dealloc]`. Anything else can be done in `-finalize`. 
The idea is, that a finalized object is still useable in the object hierarchy, but not active anymore. A good example, where this is useful, is a window controller, where the window close button has been clicked. It may still redraw, but it doesn’t react to any event actions any more.


## `-performFinalize` runs `-finalize` on demand

You can use `-performFinalize` to finalize an object “manually”, but you shouldn't call `-dealloc` manually on a reference
counted object. 

{% include note.html content="Never call `-finalize` directly, always use `-performFinalize`." %}


## Caveat

`-finalize` is single-threaded, just like `-init` and `-dealloc` when called during `release`. When you `-performFinalize` 
it can only be guaranteed  that no other thread will be executing `-finalize` (ever). But it is _not guaranteed_ that
no other thread is accessing the object. 

{% include note.html content="What's the deal with the `clearer` in `struct _mulle_objc_property` ?
It's an optimization so that the clearer code doesn't need to run for objects, that have no usefully clearable properties."
%}
