---
title: forward
keywords: class
last_updated: March 26, 2019
tags: [runtime]
summary: "MulleObjC forward speed makes object composition an alternative"
sidebar: mydoc_sidebar
permalink: mydoc_forward.html
folder: mydoc
---

{% include note.html content='See Objective-C Runtime Programming Guide for more information about `NSInvocation` and forwarding in general. Most if not all of it is applicable to MulleObjC' %}

## Introduction

One of the "Patterns" of OO programming is composition. Basically you add
references  to other objects into your object and forward messages to them.
An example of composition would be this:

```
@interface MyOrderedDictionary : NSDictionary
{
   NSDictionary   *_other;
   NSArray        *_order;
}
- (NSUInteger) count;
- (id) objectAtIndex:(NSUInteger) index;
- (id) objectForKey:(id <NSCopying) key;

@end
```

```
@implementation MyOrderedDictionary

- (NSUInteger) count
{
   return( [_order count]);
}

- (id) objectAtIndex:(NSUInteger) index
{
   return( [_order objectAtIndex:index]);
}

- (id) objectForKey:(id <NSCopying) key
{
   return( [_other objectForKey:key]);
}

@end
```

This is nice but can get tedious if you need to implement a lot of methods.

### Less typing with forwarding and NSInvocation

Once you have this code in place, you can forward all unknown method calls to
the array instance but send  `-objectForKey:` to the dictionary instance:

```
@implementation MyOrderedDictionary

- (NSMethodSignature *) methodSignatureForSelector:(SEL) sel
{
   if( sel == @selector( objectForKey:)
      return( [_other methodSignatureForSelector:sel]);
   return( [_order methodSignatureForSelector:sel]);
}


- (void) forwardInvocation:(NSInvocation *) anInvocation
{
   if( [anInvocation selector] == @selector( objectForKey:)
      [anInvocation setTarget:_other];
   else
      [anInvocation setTarget:_order];
   [anInvocation invoke];
}

@end
```

This is still a lot of typing, it's also slow. It's not as slow as in the Apple runtime (ca. 10* faster) but
still quite slow.

### Even less typing with forward:

As selectors are a type of integer in **mulle-objc**, we can even use a switch here:

```
@implementation MyOrderedDictionary

- (void *) forward:(void *) _param
{
   switch( _cmd)
   {
   case @selector( objectForKey:) :
      target = _other;
      break;

   default:
      target = _order;
      break;
   }
   return( mulle_objc_object_call( target, (mulle_objc_methodid_t) _cmd, _param));
}

@end
```

This is way faster than using NSInvocation and the difference to a handcoded forward method
as in the introduction is minimal. This makes composition feasible.


