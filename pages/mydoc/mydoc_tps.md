---
title: tps
keywords: class
last_updated: March 26, 2019
tags: [runtime]
summary: ""
sidebar: mydoc_sidebar
permalink: mydoc_tps.html
folder: mydoc
---

{% include note.html content="If you are using the **MulleFoundation**, then tagged pointers will be used for **NSNumber** and **NSString** leaving little (64 bit) or no (32 bit) room for own tagged pointer classes." %}

## Create a tagged pointer (TPS) class 

A tagged pointer class is great, if you have a lot of instances that are extremely small. Let's say you want to encode a 24 bit color in a tagged pointer, here's how to do it.


### Choose a free index

On 32 bit you have 1-3 available, on 64 bit it is 1-7. You can use this function
to search for a free index:

```
i =  mulle_objc_universe_search_free_taggedpointerclass( universe);
if( ! i)
   return( i);
```

###  Let the TPS class inherit your class

Subclass your color class and adorn your `@interface` declaration with the `MulleObjCTaggedPointer` protocol:
Your class must be abstract and not contain any instance variables.
Use `#ifdef __MULLE_OBJC_TPS__` around your code, as the user can turn off TPS code with a compiler option.
Your code should run fine without TPS enabled (just don't use the TPS class then).

```
#ifdef __MULLE_OBJC_TPS__

@interface MyTPSColor : MyColor <MulleObjCTaggedPointer>
@end

#endif
```

### Create a +load method

This will hookup your class into the TPS system at runtime. It's assumed you are using a fixed number scheme here and
the TPS index chosen is '3'.


```
#ifdef __MULLE_OBJC_TPS__

@implementation MyTPSColor

+ (void) load
{
   if( MulleObjCTaggedPointerRegisterClassAtIndex( self, 0x3))
   {
      perror( "Need tag pointer aware runtime for MyTPSColor with empty slot #3\n");
      abort();
   }
}
@end

#endif
```

### Create TPS instance depending on input

Convert you color to a 24 bit value and create the instance with the `C` function `MulleObjCCreateTaggedPointerWithUnsignedIntegerValueAndIndex`. Do not use `+alloc`!

```
static inline MyColor   *TPSColorNew( unsigned char r, unsigned char g , unsigned char b)
{
   NSUInteger   value;
   
   value = (((NSUInteger) << 16) | ((NSUInteger) g << 8) | (NSUInteger) b);
   return( (MyColor *) MulleObjCCreateTaggedPointerWithUnsignedIntegerValueAndIndex( value, 0x3));
}
```

### Retrieve value from TPS instance 

```
- (unsigned char) getRedComponent
{

static inline MyColor   *TPSColorNew( unsigned char r, unsigned char g , unsigned char b)
{
   NSUInteger   value;
   
   value = MulleObjCTaggedPointerGetUnsignedIntegerValue( self);
   return( value >> 16);
}
```

And that's about it.



