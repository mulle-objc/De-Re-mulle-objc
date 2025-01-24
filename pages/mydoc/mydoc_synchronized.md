---
title: Synchronized is gone
keywords: locking
last_updated: March 26, 2019
tags: [compiler,runtime]
summary: "Synchronized as a keyword and property is not available"
permalink: mydoc_synchronized.html
folder: mydoc
---

{% include note.html content='See <a href="https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafety/ThreadSafety.html#//apple_ref/doc/uid/10000057i-CH8-SW16">Threading Programming Guide</a> for more information about <tt>@synchronized</tt>.' %}


## Use mulle-thread for least hassle.

[mulle-thread](//github.com/mulle-concurrent/mulle-thread)
is available on all platforms, that run Objective-C.

Use `mulle_thread_mutex_t` to transform

``` objc
- (void) myFunction
{
   @synchronized()
   {
   }
}
```

to


``` objc
static mulle_thread_mutex_t   lock;


+ (void) load
{
   mulle_thread_mutex_init( &lock);
}

+ (void) unload
{
   mulle_thread_mutex_done( &lock);
}

- (void) myFunction
{
   mulle_thread_mutex_lock( &lock);
   {

   }
   mulle_thread_mutex_unlock( &lock);
}

```


## Use NSLock instead


``` objc
static NSLock   lock;


+ (void) initialize
{
   if( ! lock)
      lock = [NSLock new];
}

+ (void) deinitialize
{
   if( lock)
   {
      [lock release];
      lock = nil;
   }
}


- (void) myFunction
{
   [lock lock];
   {

   }
   [lock unlock];
}

```

### Good points

* code works in all runtimes without another dependency
* `+deinitialize` will not be called by other runtimes, it's a harmless addition

### Bad points

* A **NSLock** is slower than a `mulle_thread_mutex_t`
* The lock has not become a proper mulle-objc root object, so this code will leak in tests.

You could fix this with deleting `+deinitialize` and rewriting `+initialize` as:

``` objc
+ (void) initialize
{
   if( ! lock)
   {
      lock = [NSLock new];
#ifdef __MULLE_OBJC__
      [lock _becomeRootObject];
      [lock release;]
#endif
   }
}

// + (void) deinitialize clashes with  _becomeRootObject and must be removed
```