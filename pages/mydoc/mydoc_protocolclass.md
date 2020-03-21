---
title: Protocolclasses allow default implementations
keywords: protocol class protocolclass
last_updated: March 26, 2019
tags: [runtime, 10.0.0]
summary: "Protocolclasses allow default implementations"
permalink: mydoc_protocolclass.html
folder: mydoc
---

A *protocolclass* is a mulle-objc extension of the Objective-C language. It allows
a class to inherit default implementations from a protocol.

`@protocolclass` as a keyword doesn't exist yet, but it's effect can be
simulated by: `@class Foo; @protocol Foo; @end; @interface Foo <Foo>; @end`.

For a class to become a protocolclass it must meet the following
requirements:

* it must be a root class (not inherit from another class)
* it must implement the protocol of the same name
* it must not implement any other protocols
* it must not have instance variables

Also a protocolclass can not have any categories, this isn't enforced, but
categories on protocolclass aren't used by the runtime for method lookup.
The protocol of the protocolclass can adopt other protocols.

## A protocolclass with a default implementation of a method

### future

This is how it will look like at some point in the future:

```objective-c
@protocolclass Foo
@optional
- (int) someValue;
@end

@implementation Foo 

- (void) someValue
{
   return( 1848);
}

@end

@interface AdoptingClass : NSObject <Foo>
@end

@implementation AdoptingClass
@end
```

The use of `@optional` for `-someValue` allows it to be used as a default implementation, where
an adopting class does not get a warning, if it doesn't implement it. A `@protocolclass` must
implement the `@optional` methods. 


### now

This is how it looks like now without macros:

```objective-c
@class Foo;              
@protocol Foo
@optional
- (int) someValue;
@end

@interface Foo <Foo>
@end

@implementation Foo 

- (void) someValue
{
   return( 1848);
}

@end

@interface AdoptingClass : NSObject <Foo>
@end

@implementation AdoptingClass
@end
```

The declaration of `@class Foo` before `@protocol Foo` signals that this is a protocolclass.
Notice how the class `Foo` is adopting it's protocol `Foo` of the same name. It is a root class.

This will give you a number of compiler warnings, due to root classes being used and so forth.

### now with macros

`PROTOCOLCLASS` macros can make your life a little easier, by removing some typework
and by removing the compiler warnings. 

Macro                                 | Description
--------------------------------------|-----------------------------------------------------
`PROTOCOLCLASS_INTERFACE( name, ...)` | Declare a *protocolclass* that adopts other protocols
`PROTOCOLCLASS_INTERFACE0( name)`     | Declare a *protocolclass* that adopts no other protocols
`PROTOCOLCLASS_IMPLEMENTATION( name)` | Define a *protocolclass* 
`PROTOCOLCLASS_END()`                 | Terminate either a *protocolclass* declaration or definition


Thus the above example can be transformed with macros into:

`Foo.h`:

```objective-c
PROTOCOLCLASS_INTERFACE0( Foo)
@optional
- (int) someValue;
PROTOCOLCLASS_END()

PROTOCOLCLASS_IMPLEMENTATION( Foo)

- (void) someValue
{
   return( 1848);
}

PROTOCOLCLASS_END()

@interface AdoptingClass : NSObject <Foo>
@end

@implementation AdoptingClass
@end
```

Due to deficiences in the way variadic arguments are handled in C macros, you must use
`PROTOCOLCLASS_INTERFACE0` instead of `PROTOCOLCLASS_INTERFACE`, if your protocolclass
adopts no further protocols.

## A protocolclass with a property

### future

```objective-c
@protocolclass Foo
@property int  someValue;
@end

@implementation Foo 
@end

@interface AdoptingClass : NSObject <Foo>
@end

@implementation AdoptingClass
@end
```

The adoptingClass will implement the property.


### now

This is how it looks like now without macros:

```objective-c
@class Foo;              
@protocol Foo
@property int someValue;
@end

@interface Foo <Foo>
@property int someValue; 
@end

@implementation Foo 
@end

@interface AdoptingClass : NSObject <Foo>
@property int someValue; 
@end

@implementation AdoptingClass
@end
```

You must redeclare the property in the adopting class.

### now with macros

Now with even more macros:

```objective-c

#define FooProperties \
@property int someValue

PROTOCOLCLASS_INTERFACE0( Foo)
FooProperties;
PROTOCOLCLASS_END()

PROTOCOLCLASS_IMPLEMENTATION( Foo)
PROTOCOLCLASS_END()

@interface AdoptingClass : NSObject <Foo>
FooProperties;
@end

@implementation AdoptingClass
@end
```


## Supplement an existing protocol with protocolclass methods

When you do this, your protocolclass should adopt that other protocol
and redeclare those methods, for which implementations are provided as
`@optional`.

{% include note.html content="Redeclaration as optional is a mulle-objc specific feature." %}


## Calling NSObject methods from your protocolclass methods

If your protocolclass wants to use NSObject methods, it should declare this
in its protocol. 

```objective-c
#import <Foundation/Foundation.h>

PROTOCOLCLASS_INTERFACE( MyProtocolClass, NSObject)
@optional
- (void) doSomethingWithObject:(id) object;
PROTOCOLCLASS_END()

PROTOCOLCLASS_IMPLEMENTATION( Foo)
- (BOOL) doSomethingWithObject:(id<MyProtocolClass>) object
{
   return( [object isKindOfClass:[NSString class]]);
}
PROTOCOLCLASS_END()
```

## Things to watch out for


### Reaching the protocolclass via super

In the class adopting your protocol, a call to super will first search the protocolclasses in order
of adoption then the superclass, in the case  `MyClass` that is `Foo` first then `NSObject`.

### Calling super from the protocolclass

{% include warning.html content="Not recommended!" %}

As a protocolclass is a root class, there is no way to call **super** from a protocolclass. There is a way 
around this though.

You can search for the overridden implementation of a selector, given the class and category of the
implementation.

```
   IMP   imp;
   
   imp = MulleObjCObjectSearchOverriddenIMP( self, @selector( doTheFooThing), @selector( Foo), 0);
   return( (*imp)( self, @selector( doTheFooThing), self));
```

This works fine, unless the receiver is implementing the same protocolclass again and is calling super.

