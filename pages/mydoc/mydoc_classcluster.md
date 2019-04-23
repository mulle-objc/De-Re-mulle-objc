---
title: classcluster
keywords: class
last_updated: March 26, 2019
tags: [runtime,library]
summary: ""
permalink: mydoc_classcluster.html
folder: mydoc
---


## UNTESTED DRAFT 

A classcluster is a fairly complicated setup, that is used to hide implementation details of various classes under one common name. **mulle-objc** simplifies the setup, but it is by no means simple. 

As an example, we want to create a classcluster for a [**BitSet**](https://en.wikipedia.org/wiki/Bitset) class.
We assume, that in the majority of cases, the bitset will be empty. So as an optimization we want to provide a special
**EmptyBitSet** class, to conserve space. Otherwise 

We also want to have a mutable variant **MutableBitSet**, that is a subclass of **BitSet** (and not the other way around,
like in Apple Foundation).


## The base class

This is the "user" facing class. All other classes will be more or less hidden. This class defines the API.
It also adopts the MulleObjCClassCluster protocolclass. 

```
@interface BitSet : NSObject < MulleObjCClassCluster>

- (instancetype) initWithBits:(NSUInteger *) bits
                        count:(NSUInteger) count;
@end

// methods to be implemented by classcluster classes
@interface BitSet( ClassCluster)
- (BOOL) boolAtIndex:(NSUInteger) index;
@end
```

The implementation now either produces an **EmptyBitSet** or a **ConcreteBitSet**, depending on all input
bits being clear or not:

```
#import "BitSet.h"

@implementation BitSet

- (instancetype) init
{
    return( [[EmptyBitSet sharedInstance] retain]);
}

- (instancetype) initWithBits:(NSUInteger *) bits
                        count:(NSUInteger) count
{
   NSUInteger   *p;
   NSUInteger   *sentinel;
  
   p        = bits;
   sentinel = &p[ count];
   while( p < sentinel)
      if( *p++)
         return( [ConcreteBitset newWithBits:bits
                                       count:count]);
   return( [[EmptyBitSet sharedInstance] retain]);
}

@end
```


#### Some notes on the implementation.

As we are implementing a classcluster, we know that the `-initWithBits:count:` method is operating on a special kind of
object, the placeholder. A placeholder is a constant instance of **BitSet** in our case. A constant instance ignores
all -retain/-release calls, so we do not need to `-[self release]` in `-initWithBits:count:` to avoid leaks.

We are using a shared instance for **EmptyBitSet** to reduce the footprint of the application. Only one instance of
this immutable bitset will be generated.

{% include "note.html" contents="Memo: **EmptyBitSet** is sort of superflous, if **ConcreteBitSet** with zero length would also be usable as a singleton. That would save a class" %}

## The concrete classes

The **EmptyBitSet** is very simple, as the instance creation is done with `+sharedInstance` provided
by `MulleObjCSingleton` already:


```
#import "BitSet.h"

@interface EmptyBitSet : BitSet <MulleObjCSingleton>

- (BOOL) boolAtIndex:(NSUInteger) index;

@end
```

```
#import "EmptyBitSet.h"

@implementation EmptyBitSet

- (BOOL) boolAtIndex:(NSUInteger) index
{
    return( NO);
}
@end
```

```
#import "BitSet.h"

@interface ConcreteBitSet : BitSet 
{
    NSUInteger   *_bits;
    NSUInteger   _count;
}

- (BOOL) boolAtIndex:(NSUInteger) index;

@end
```

In the case of **ConcreteBitSet** we need to be aware that we are subclassing the placeholder class **BitSet**. So 
`+alloc` will just produce the same placeholder object that 'self' already is. We therefore need to implement the 
instance creation and deallocation with primitive runtime functions ourselves:

```
#import "ConcreteBitSet.h"

@implementation ConcreteBitSet

- (id) newWithBits:(NSUInteger *) bits
             count:(NSUInteger) count
{
    ConcreteBitSet  *set;
    size_t          size;
    
    set         = NSAllocateObject( self, 0, NULL);
    size        = sizeof( NSUInteger) * count;
    set->_bits  = MulleObjCObjectAllocateNonZeroedMemory( set, size);
    set->_count = count;
    memcpy( set->_bits, bits, size);
    return( set);
}

- (void) dealloc
{
   MulleObjCObjectDeallocateMemory( self->_bits);
   NSDeallocateObject( self);
}

- (BOOL) boolAtIndex:(NSUInteger) index
{
   NSUInteger  i;
   NSUInteger  bit;
   
   i   = index / (sizeof( NSUInteger) * CHAR_BIT);
   bit = 1 << (index & (sizeof( NSUInteger) * CHAR_BIT - 1)); 
   
   if( i >= _count)
      return( NO);
   return( _bits[ i] & bit ? YES : NO);
}

@end
```

## Adding a class to a classcluster

You chance upon the [CountOnes](https://github.com/CountOnes/hamming_weight) project and its AVX2 implementation 
and would like to  support it, for larger bitsets.

You could either add a new `-init` function to **BitSet** or expand the current initializer:


- (instancetype) initWithBits:(NSUInteger *) bits
                        count:(NSUInteger) count
{
   NSUInteger   *p;
   NSUInteger   *sentinel;
  
   p        = bits;
   sentinel = &p[ count];
   while( p < sentinel)
      if( *p++)
         if( count >= 16)
             return( [ConcreteAVX2Bitset newWithBits:bits
                                               count:count]);
         else
             return( [ConcreteBitset newWithBits:bits
                                           count:count]);
   return( [[EmptyBitSet sharedInstance] retain]);
}
```

## Subclassing a classcluster

The main obstacle to subclassing a classcluster is the reimplementation of the instance allocation methods.
You should reimplement the following methods in your subclass:

```
+ (instancetype) alloc
{
   return( NSAllocateObject( self, 0, NULL));
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( NSAllocateObject( self, 0, NULL));
}


+ (instancetype) new
{
   return( [NSAllocateObject( self, 0, NULL) init]);
}
```

Now your subclass and its subclass will create instances of the proper class. But you will also need to override
the init functions of the classcluster. In the case of **BitSet** there is only one `-initWithBits:count:`, which 
makes this easy.

## Classcluster on top of classcluster

It's entirely possible to create a classcluster on top of another classcluster, as we will show
with **MutableBitSet**.


