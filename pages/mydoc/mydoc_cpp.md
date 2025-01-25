---
title: Objective-C++
keywords: protocol
last_updated: March 26, 2019
tags: [compiler]
summary: "It's just not a good idea"
permalink: mydoc_cpp.html
next_page: mydoc_xcodeproj.html
folder: mydoc
---

{% include note.html content="C++ is already the most complex language in the
world and adding Objective-C on top of it, is like the worst of both worlds." %}


## Use C++ from Objective-C

Create a C code wrapper to call the C++ functions. Then call the C code from
Objective-C.


C++

`cpp.h:`

``` c++
#ifdef __cplusplus
extern "C"
{
#endif
   void  call_cpp1( char *);
   char  *call_cpp2( void);
#ifdef __cplusplus
};
#endif
```

Objective-C



`foo.m`

``` objc
#include <cpp.h>

@implementation Foo

- (void) callCPlusPlus1:(char *) s
{
   call_cpp1( s);
}

- (char *) callCPlusPlus2
{
   return( call_cpp2);
}

@end
```

## Use Objective-C from C++

This is possible too, but you need to link against the `mulle-objc-runtime.h`
only:


> TODO: test this does this work with mulle-c11 ?

``` objc
#ifdef __cplusplus
extern "C"
{
#include <mulle-objc/mulle-objc-runtime.h>
};
#endif
```

Now you can use the runtime functions to create instances and call them.
It's very cumbersome though.





