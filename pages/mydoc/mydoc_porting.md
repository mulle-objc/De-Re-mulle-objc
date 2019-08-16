---
title: sde
keywords: class
last_updated: May 3, 2019
tags: [runtime,foundation,porting]
summary: ""
permalink: mydoc_porting.html
folder: mydoc
---

## Tips

### Use envelope headers

Rewrite code that imports specific headers to use the envelope header.

Example: Rewrite


```
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
```

to

```
#import <Foundation/Foundation.h>
```

The exception being `<Foundation/NSDebug.h>` or any other header not exposed by `<Foundation/Foundation.h>`.

### Find and correct uses of `class_getInstanceSize`  

Two typical uses for `class_getInstanceSize` are

1. retrieve the amount of memory required to create an instance
2. locate the "extra" bytes allocated by `NSAllocateObject` at the end of an instance

#### Instance creation

The number of bytes returned by `class_getInstanceSize` is the amount of bytes required to hold an instance.
But the actual object will be at an offset. Pass the allocated memory to  `objc_constructInstance`
and use the return value as the instance pointer. 

```
id        obj;
size_t    size;
void      *allocation;

size       = class_getInstanceSize( cls);
allocation = calloc( 1, size);
obj        = objc_constructInstance( cls, allocation);
...
allocation = object_getAlloc( obj);
free( allocation);
```

#### Access extra bytes

Remember that your class may be subclassed. An offset from the last known instance variable
in your class implementation may not be correct. 

The proper and portable way to get a pointer to the extra bytes is:

```
size_t    size;
void      *allocation;
void      *extra;

size       = class_getInstanceSize( object_getClass( self));
#ifdef __MULLE_OBJC__
allocation = object_getAlloc( obj);
#else
allocation = obj;
#endif
extra      = &((char *) allocation)[ size];
```

{% include note.html contents="`object_getAlloc` is defined in [objc-compat](https://github.com/MulleFoundation/objc-compat). 
If you don't have it you can easily implement it for non mulle-objc runtimes as 
`static inline void  *objc_getAllocation( id obj) { return( obj); }`" %}

If you use [objc-compat](https://github.com/MulleFoundation/objc-compat), you can use `object_getExtraBytes`, which does
exactly the above.


### Register composed selectors before using messaging

If you compose a selector from a C string, you must then use `sel_registerName` to acquire a `SEL` from the string. 
Then use this `SEL` for messaging. (You can also use `NSSelectorFromString`)

### Find and correct uses of `objc_msgSend` and `objc_msgSend_stret`

Use the [mulle-objc MetaABI](https://www.mulle-kybernetik.com/weblog/2015/mulle_objc_meta_call_convention.html)
convention to pass parameters and inspect return values.


### Find and correct uses of `Protocol` 

`Protocol *` does not exist. Replace it with `PROTOCOL`. You can not treat `PROTOCOL` as an object
and message it. 

### Find `+initialize` and `+load` methods and add dependency information

The proper dependencies must be declared, the only known dependency to exist is the runtime during loading and initialization. Everything else must be declared.

```
MULLE_OBJC_DEPENDS_ON_LIBRARY( Foundation);
```

#### Issues

* the runtime only knows about protocols that are adopted by a class
* PROTOCOL in mulle-objc is a hash value (like a selector) a different type
* you can not message protocols


### There is no enveloping NSAutoreleasePool around `+load in mulle-objc

If you create ephemeral instances in your `+load` method, you should wrap the code yourself inside an `NSAutoreleasePool`.


