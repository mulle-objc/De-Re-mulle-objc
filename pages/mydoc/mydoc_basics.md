---
title: Basics
keywords: class
last_updated: March 26, 2019
tags: [runtime,library]
summary: ""
permalink: mydoc_basics.html
folder: mydoc
---

Lets write a MulleObjC class that highlights all the basics of memory management
and being a good class in the MulleObjC runtime. Some of the topics are seldom
employed in the average Objective-C class, but it's good to be aware of them.

The main takeaway points are

* use `-release` only in `-init` and `-dealloc`
* use `-autorelease` everywhere else
* protect your setters with `NSParameterAssert`
* `+load` and `+initialize` behave as expected if you declare `MULLE_OBJC_DEPENDS_ON_LIBRARY`
* try to write proper `+unload` and `+deinitialize` methods to be a well behaved class, that doesn't leak in tests
* ARC is not compatible with MulleObjC, use manual `-retain/-release/-autorelease` memory management methods


## Foo does it all

```
#import <Foundation/Foundation.h>

@interface Foo : NSObject
{
   NSNumber   *_a;
   NSArray    *_kids;
}

@property( copy) NSNumber *b;

@end


@implementation Foo

// class variables are declared as static
static Class                  FooClass;
static mulle_thread_mutex_t   *lock;
static NSDictionary           *lookupTable;
static char                   *info;


// Ensure that Foundation is loaded completely before our class
MULLE_OBJC_DEPENDS_ON_LIBRARY( Foundation);

// run as soon as class is added to the runtime
+ (void) load
{
   FooClass = self;

   lock = mulle_malloc( struct mulle_thread_mutex_t)
   mulle_thread_mutex_init( lock);
}

// run when the universe winds down
+ (void) unload
{
   mulle_free( lock);
}


// run when the class is messaged for the first time
+ (void) initialize
{
   if( ! lookupTable)
   {
      lookupTable = [@{ @"a": @1,
                      @"b": @2,
                      @"c": @3
                    } retain];
      info = mulle_strdup( "some text");
   }
}


// run when the universe winds down (before unload)
+ (void) deinitialize
{
   [lookupTable release];
   lookupTable = nil;
   mulle_free( info);
   info = NULL;
}


- (id) init
{
   _a = [[NSNumber alloc] initWithInt:18];
   _b = [[NSNumber alloc] initWithInt:48];
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
- (void) addKid:(Foo *) a
{
   NSParameterAssert( [a isKindOfClass:[Foo class]]);
   [_kids addObject:a];
}


@end
```


### MULLE_OBJC_DEPENDS_ON_LIBRARY

`MULLE_OBJC_DEPENDS_ON_LIBRARY` is only required if you are implementing
`+load`, `+unload`, `+initialize`, `+deinitialize`.

This will ensure that classes of the named library have been loaded, so that
your code will work as expected. You should usually specify **Foundation**
at least.

If you want to specify classes and categories in a more finegrained way, see
[dependencies](mydoc_dependencies.html).



### +load

```
+ (void) load
{
   FooClass = self;

   lock = mulle_malloc( struct mulle_thread_mutex_t)
   mulle_thread_mutex_init( lock);
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

`+unload` is MulleObjC specific and does not exist in other runtimes. The
MulleObjC Objective-C runtime is contained in a "universe", that is
destructible. So `+unload` is a facility to release resources acquired by
`+load`. When this is properly done by all classes, it makes for instance
memory leak  checking that much more convenient.

```
+ (void) unload
{
   mulle_free( lock);
}
```


### +initialize

```
+ (void) initialize
{
   if( ! lookupTable)
   {
      @autoreleasepool
      {
         lookupTable= [@{ @"a": @1,
                         @"b": @2,
                         @"c": @3
                       } retain];
      }
      info = mulle_strdup( "some text");
   }
}
```

`+intialize` is the best time to instantiate class variables, that are defined
as static variables.

* `+initialize` is only called for classes not for categories
* your `+initialize` is called by subclasses, if they don't implement `+initialize` themselves
* it is OK for subclasses to call `+[super initialize]` if a superclass defines it
* your class will get it's `+initialize` call first before subclasses

So to avoid leaks, check if your variables aren't already initialized.


### +deinitialize

`+deinitialize` is only called if `+initialize` has been called. If you did not
implement `+initialize` then `+deinitialize` has no effect.

You should release all resources, that were allocated during `+initialize`.

* `+deinitialize` is only called for classes not for categories
* it is OK for subclasses to call `+[super deinitialize]` if a superclass defines it
* subclasses will get the `+deinitialize` call first before superclasses

```
+ (void) deinitialize
{
   mulle_free( info);
   info = NULL;      // a second deinitialize can't hurt us now
}
```

### -init

```
- (id) init
{
   _a = [[NSNumber alloc] initWithInt:18];
   _b = [[NSNumber alloc] initWithInt:48];
   _kids = [[NSMutableArray array] retain];

   return( self);
}
```

Calling `-[super init]` if `NSObject` is the direct superclass is superflous
and can be avoided. MulleObjC uses manual retain counting, so `-retain` what 
needs to be retained by the instance.


### -finalize

```
- (void) finalize
{
   [_kids autorelease];
   _kids = nil;
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

```
- (void) dealloc
{
   [_a release];
   [super dealloc];
}
```

Non property instance variables should be freed manually. You can do this
also in `-finalize`, but often an object needs some values until the very end.


### -setA:

```
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

```
   p = [Foo new];
   ...
   [p release];
   // p is never used again in this function
```


### -a

```
- (NSNumber *) a
{
   return( _a);
}
```


Because of the strict use of `-autorelease` in the setters, we don't have to
do `[[obj retain] autorelease]` shenanigans, but can just return the instance
variable.


### -addKid:

```
- (void) addKid:(Foo *) a
{
   NSParameterAssert( [a isKindOfClass:[Foo class]]);
   [_kids addObject:a];
}
```

We can not add *nil* to an array. So the assert ensures that
`a` is nonnil and of the proper class.


## Next

With the basics covered, the next topic is
[how to write good MulleObjC code](mydoc_good.html).
