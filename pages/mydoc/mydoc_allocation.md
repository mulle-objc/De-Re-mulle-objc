---
title: Allocation
keywords: class
last_updated: February 26, 2022
tags: [language]
summary: "Allocation functions"
permalink: mydoc_allocation.html
folder: mydoc
---

## Intro

Low level heap memory allocation in C is done with `malloc` and `free`.
In Objective-C high level autoreleased memory allocation is done with
`[[NSMutableData dataWithLength:] mutableBytes]`.

MulleObjC provides some memory functions for all purposes that are "inbetween".


### struct mulle_allocator

First up, every allocation in mulle-objc is done through a mulle-allocator.
Using the (hidden) `mulle_default_allocator`, C code simplifies from

``` c
p = alloc( 1848);
if( ! p)
{
   perror( "malloc:");
   exit( 1);
}
```

to

``` c
p = mulle_malloc( 1848);
```

> If you want to know why and how this works, read the mulle-allocator [README.md](//github.com/mulle-c/mulle-allocator/blob/release/README.md)


### Creating autoreleased and zeroed memory

If `NSMutableData` is not available, you can use `MulleObjCCallocAutoreleased`
to create an autoreleased and zeroed block of memory. Note that the block
_will_ be reclaimed by the enclosing NSAutoreleasePool.

``` c
p = MulleObjCCallocAutoreleased( 1, sizeof( struct whatever));
```


### Creating instances

The usual way to create an instance is +new or a combination of +alloc and an
-init method. The actual allocation is hidden inside the +new/+alloc methods.

> Nomenclauture: Classes create instances. Classes and instances are objects.
> ![](images/object-class-instance.svg)

The default implementation of `+alloc` is:

``` objc
+ (instancetype) alloc
{
   return( _MulleObjCClassAllocateInstance( self, 0));
}
```


You can call `_MulleObjCClassAllocateInstance` directly, to create an instance.
This can be usefule when writing your own `+alloc` or `+new` method.


Calling `_MulleObjCClassAllocateInstance` on not self-written classes,
may create unexpected side-effects or errors. You need to consider, if the
class is a [TPS](mydoc_tps.html) class or a [Singleton](mydoc_singleton.html)
class or a [Classcluster](mydoc_classcluster.html) or any class that may do
something special in `+alloc`.


`_MulleObjCClassAllocateInstance` destills down to the following code:

``` c
   struct mulle_allocator   *allocator;

   allocator = _mulle_objc_infraclass_get_allocator( infra);
   return( __mulle_objc_infraclass_alloc_instance_extra( infra, extra, allocator));
```

Each class has its own allocator, that is used to allocate instances. Usually
this is the `mulle_default_allocator`. But that may vary on a per-class
basis.


### Allocating extra memory for an instance

If your instance needs some extra memory to store data, it could use
a NSMutableData instance variable:

``` objc
@interface Foo
{
   NSMutableData   *_buffer;
}

- (void *) bytes;

@end


- (instancetype) initWithLength:(NSUInteger) length
{
   _buffer = [[NSMutableData alloc] initWithLength:length]
   return( self);
}


- (void *) bytes
{
   return( [_buffer mutableBytes]);
}


- (void) dealloc
{
   [_buffer release];
   [super dealloc];
}
```

A disadvantage of this scheme is, that you don't have control over the
allocator used to create the memory. That control lies with *NSMutableData*.
To use the allocator, the instance was created with, use
`MulleObjCInstanceAllocateMemory`:



``` objc
@interface Foo
{
   void   *_buffer;
}

- (void *) bytes;

@end


- (instancetype) initWithLength:(NSUInteger) length
{
   _buffer = MulleObjCInstanceAllocateMemory( self, length);
   return( self);
}


- (void *) bytes
{
   return( buffer);
}


- (void) dealloc
{
   MulleObjCInstanceDeallocateMemory( self, _buffer);
   [super dealloc];
}
```


| MulleObjC Instance Function                  | C equivalent |
|----------------------------------------------|--------------|
| `MulleObjCInstanceAllocateNonZeroedMemory`   | `malloc`     |
| `MulleObjCInstanceReallocateNonZeroedMemory` | `realloc`    |
| `MulleObjCInstanceAllocateMemory`            | `calloc`     |
| `MulleObjCInstanceDuplicateUTF8String`       | `strdup`     |
| `MulleObjCInstanceDeallocateMemory`          | `free`       |


The same functions are also available, with `Class` as the first parameter.
These can be used in `+` class methods.


| MulleObjC Class Function                  | C equivalent |
|-------------------------------------------|--------------|
| `MulleObjCClassAllocateNonZeroedMemory`   | `malloc`     |
| `MulleObjCClassReallocateNonZeroedMemory` | `realloc`    |
| `MulleObjCClassAllocateMemory`            | `calloc`     |
| `MulleObjCClassDuplicateUTF8String`       | `strdup`     |
| `MulleObjCClassDeallocateMemory`          | `free`       |


### extraBytes and metaExtraBytes

An instance in memory looks like this:

![](images/object-layout.svg)

The address returned by `alloc` is not the beginning of the memory block
allocated for the instance. It is the address after the `isa` pointer.
The memory block is divided into the user accessible ivars and extraBytes
"self" block and the "meta" block with negative offsets from "self".

The "extraBytes" are the second parameter of  `_MulleObjCClassAllocateInstance`.
Each instance can therefore have a unique size. The amount of metaExtraBytes
is fixed for every class and instance at the start of the program. Currently
this is an experimental and unused mulle-objc-runtime feature.


### Creating an instance in pre-allocated memory

If you have sufficient memory already allocated, you can use
`MulleObjCClassConstructInstance` to turn this memory into one or as
many instances as can fit.


`MulleObjCClassGetInstanceSize` calculates the size needed for the memory
allocation and `MulleObjCClassConstructInstance` zeroes the memory and
initializes `isa` and the `retainCount`.


```
size_t   size;
void     *block;
Class    myClass;
id       obj;

...
size  = MulleObjCClassGetInstanceSize( myClass);
block = my_malloc(size);
obj   = MulleObjCClassConstructInstance( myClass, block, size, NO);
...
my_free( obj);
```

There are a lot of caveats:

* ascertain that -dealloc doesn't interfere with your memory scheme
* ascertain that all instance variables are freed before deallocing
* calling -init may trigger -release  and therefore -dealloc in an error case


Reasonably, this scheme can only be used for very simple value type objects.
