---
title: Basics
keywords: class
last_updated: March 26, 2019
tags: [runtime,library]
summary: ""
permalink: mydoc_basics.html
folder: mydoc
---

Lets write a mulle-objc class that highlights all the basics of memory management
and being a good class in the mulle-objc runtime. Some of the topics are seldom
employed in the average Objective-C class, but it's good to be aware of them.

The main takeaway points are

* use `-release` only in `-init` and `-dealloc`
* use `-autorelease` everywhere else
* protect your setters with `NSParameterAssert` (if using Foundation, else use `assert`)
* `+load` and `+initialize` behave as expected if you declare `MULLE_OBJC_DEPENDS_ON_LIBRARY`
* try to write proper `+unload` and `+deinitialize` methods to be a well behaved class, that doesn't leak in tests
* ARC is not compatible with mulle-objc, use manual `-retain/-release/-autorelease` memory management methods


## Foo does it all

``` objc
#import <Foundation/Foundation.h>

@interface Foo : NSObject
{
   NSNumber   *_a;
   NSArray    *_kids;
}

@property( copy) NSNumber *b;

+ (NSNumber *) lookup:(NSString *) key;
- (void) addToKids:(Foo *) a;

@end


@implementation Foo

// class variables are declared as static. It's somewhat convenient to wrap
// these into a struct. In most cases you will need to protect your class
// variables with a lock.

static struct
{
   mulle_thread_mutex_t   _lock;

// mutable, needs locking
   NSMutableDictionary    *_lookupTable;

// immutable, need no locking
   Class                  _FooClass;
   char                   *_info;
} Self;


// Ensure that Foundation is loaded completely before our class
MULLE_OBJC_DEPENDS_ON_LIBRARY( Foundation);

// run as soon as class is added to the runtime
+ (void) load
{
   Self._FooClass = self;

   mulle_thread_mutex_init( &Self._lock);
}


// run when the universe winds down
+ (void) unload
{
   mulle_thread_mutex_done( &Self._lock);
}


// run when the class is messaged for the first time
+ (void) initialize
{
   if( ! Self._lookupTable)
   {
      Self._lookupTable = [@{ @"a": @1,
                              @"b": @2,
                              @"c": @3
                            } mutableCopy];
      Self._info = mulle_strdup( "some text");
   }
}


// run when the universe winds down (before unload)
+ (void) deinitialize
{
   [Self._lookupTable release];
   Self._lookupTable = nil;
   mulle_free( Self._info);
   Self._info = NULL;
}


+ (NSNumber *) lookup:(NSString *) key
{
   NSNumber   *value;

   mulle_thread_mutex_lock( &Self._lock);
   {
      value = [Self._lookupTable objectForKey:key];
      value = [[value retain] autorelease];
   }
   mulle_thread_mutex_unlock( &Self._lock);
   return( value);
}


- (id) init
{
   _a    = [[NSNumber alloc] initWithInt:18];
   _b    = [@48 retain];
   _kids = [[NSMutableArray array] retain];

   return( self);
}


// run before dealloc, can be triggered with -performFinalize
- (void) finalize
{
   [_kids autorelease];
   _kids = nil;

   [super finalize];
}


- (void) dealloc
{
   [_a release];
   [super dealloc];
}


// typical value/toOne setter code
- (void) setA:(NSNumber *) a
{
   NSParameterAssert( ! a || [a isKindOfClass:[NSNumber class]]);

   [_a autorelease];
   _a = [a copy];
}


// typical getter code
- (NSNumber *) a
{
   return( _a);
}


// typical toMany setter code
- (void) addToKids:(Foo *) a
{
   NSParameterAssert( [a isKindOfClass:[Foo class]]);
   [_kids addObject:a];
}


@end
```

## Analysing Foo step by step


### MULLE_OBJC_DEPENDS_ON_LIBRARY

``` c
// Ensure that Foundation is loaded completely before our class
MULLE_OBJC_DEPENDS_ON_LIBRARY( Foundation);
```

`MULLE_OBJC_DEPENDS_ON_LIBRARY` is only required if you are implementing
`+load`, `+unload`, `+initialize`, `+deinitialize`.

This will ensure that classes of the named library have been loaded, so that
your code will work as expected. You should usually specify **Foundation**
at least.

If you want to specify classes and categories in a more finegrained way, see
[dependencies](mydoc_dependencies.html).



### +load

``` objc
// run as soon as class is added to the runtime
+ (void) load
{
   Self._FooClass = self;

   mulle_thread_mutex_init( &Self._lock);
}
```

Load is executed as soon as your class or category is loaded. Things to
consider are:

* `main` has most likely not run yet
*  you must not call `+[super load]`
*  `+load` is called for classes and categories

Ideally your `+load` method just calls **C** functions. This is also the best
time to hack mulle-objc runtime methods if you so desire.


### +unload

`+unload` is mulle-objc specific and does not exist in other runtimes. The
mulle-objc Objective-C runtime is contained in a "universe", that is
destructible. So `+unload` is a facility to release resources acquired by
`+load`. When this is properly done by all classes, it makes memory leak
checking that much more convenient.

``` objc
+ (void) unload
{
   mulle_thread_mutex_done( &Self._lock);
}
```


### +initialize

``` objc
+ (void) initialize
{
   if( ! Self._lookupTable)
   {
      Self._lookupTable = [@{ @"a": @1,
                              @"b": @2,
                              @"c": @3
                            } mutableCopy];
      Self._info = mulle_strdup( "some text");
   }
}
```

`+intialize` is the best time to instantiate class variables, that are defined
as static variables.

* `+initialize` is only called for classes not for categories
* your `+initialize` is called by subclasses, if they don't implement `+initialize` themselves
* it is OK for subclasses to call `+[super initialize]` if a superclass defines it
* your class will get it's `+initialize` call first before subclasses
* `+initialize` is single-threaded, so you don't need to lock
* `+initialize` will be called for subclasses, that do not define their own `+initialize` method

To avoid leaks, check if your variables aren't already initialized.



### +deinitialize

`+deinitialize` is only called if `+initialize` has been called. If you did not
implement `+initialize` then `+deinitialize` has no effect.

You should release all resources, that were allocated during `+initialize`.

* `+deinitialize` is only called for classes not for categories
* it is OK for subclasses to call `+[super deinitialize]` if a superclass defines it
* subclasses will get the `+deinitialize` call first before their superclass (!)
* `+deinitialize` is running single-threaded


``` objc
+ (void) deinitialize
{
   [Self._lookupTable release];
   Self._lookupTable = nil;
   mulle_free( Self._info);
   Self._info = NULL;
}
```

To avoid crashes, zero your variables after freeing them.


### -init

``` objc
- (id) init
{
   _a    = [[NSNumber alloc] initWithInt:18];
   _b    = [[NSNumber alloc] initWithInt:48];
   _kids = [[NSMutableArray array] retain];

   return( self);
}
```

Calling `-[super init]` if `NSObject` is the direct superclass is superflous
and can be avoided. mulle-objc uses manual retain counting, so `-retain` what
needs to be retained by the instance.


### -finalize

``` objc
- (void) finalize
{
   [_kids autorelease];
   _kids = nil;

   [super finalize];
}
```

`-finalize` is the time, when properties release their values. If you are
keeping references to other objects, that aren't simple values like `NSString`
this is the time to release them. The separation of `-dealloc` and `-finalize`
can be useful to break retain cycles.

Set `nil` to your instance variables, as the object is still alive.

A finalized object can still be messaged, but an object can only be
finalized once.


### -dealloc

``` objc
- (void) dealloc
{
   [_a release];
   [super dealloc];
}
```

Non property instance variables should be freed manually. You can do this
also in `-finalize`, but often an object needs some values until the very end.


### +lookup:

```
+ (NSNumber *) lookup:(NSString *) key
{
   NSNumber   *value;

   mulle_thread_mutex_lock( &Self._lock);
   {
      value = [Self._lookupTable objectForKey:key];
      value = [[value retain] autorelease]; // if
   }
   mulle_thread_mutex_unlock( &Self._lock);
   return( value);
}
```

`+lookup` accesses a mutable class variable, therefore you should protect
the contents with a lock. You should also `retain`/`autorelease` the return
value inside the lock, to push the value into the current threads
autoreleasepool.



### -setA:

``` objc
- (void) setA:(NSNumber *) a
{
   NSParameterAssert( ! a || [a isKindOfClass:[NSNumber class]]);

   [_a autorelease];
   _a = [a copy];
}
```

Protect setters with `NSParameterAssert`. Allow `nil` to be set whenever
possible.


All code outside of `+load`/`+unload` `+initialize`/`+deinitialize`
`-init`/`-dealloc` must use **`-autorelease`**.
The only allowable use of `-release` is for ephemeral objects like in:

``` objc
   p = [Foo new];
   ...
   [p release];
   // p is never used again in this function
```


### -a

``` objc
- (NSNumber *) a
{
   return( _a);
}
```


Because of the strict use of `-autorelease` in the setters, we don't have to
do `[[obj retain] autorelease]` shenanigans, but can just return the instance
variable.


### -addToKids:

``` objc
- (void) addToKids:(Foo *) a
{
   NSParameterAssert( [a isKindOfClass:[Foo class]]);
   [_kids addObject:a];
}
```

We can not add *nil* to an array. And as `_kids` is a
`NSMutableArray` this will raise. The assert ensures that
`a` of the proper class.


## Next

With the basics covered, the next topic is
on how to utilize [objects and properties](mydoc_objects.html).
