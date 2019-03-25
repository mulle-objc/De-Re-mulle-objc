---
title: Synchronized is gone
keywords: locking
last_updated: March 26, 2019
tags: [runtime]
summary: "Synchronized as a keyword and property is not available"
sidebar: mydoc_sidebar
permalink: mydoc_synchronized.html
folder: mydoc
---

{% include note.html content='See <a href="https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Multithreading/ThreadSafety/ThreadSafety.html#//apple_ref/doc/uid/10000057i-CH8-SW16">Threading Programming Guide</a> for more information about <tt>@synchronized</tt>.' %}


Use `mulle_thread_mutex_t` to transform

```
- (void) myFunction
{
   @synchronized()
   {
   }
}
```

to


```
static mulle_thread_mutex_t   lock;


+ (void) load
{
   mulle_thread_mutex_init( &lock);
}


- (void) myFunction
{
   mulle_thread_mutex_lock( &lock);
   {

   }
   mulle_thread_mutex_unlock( &lock);
}

```