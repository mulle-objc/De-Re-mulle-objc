---
title: Protocolclasses allow default implementations
keywords: protocol class protocolclass
last_updated: March 26, 2019
tags: [runtime]
summary: "Protocolclasses allow default implementations"
permalink: mydoc_protocolclass.html
folder: mydoc
---

A *protocolclass* is an extension to the Objective-C language. It allows
a class to inherit default implementations from a protocol.

`@protocolclass` as a keyword doesn't exist yet, but it's effect can be
simulated by: `@class foo; @protocol foo; @end; @interface foo <foo>; @end`.

For a regular class to become a protocolclass it must meet the following
requirements:

* it must be a root class (not inherit from another class)
* it must implement the protocol
* it must not implement any other protocols
* it must not have instance variables

Also a protocolclass can not have any categories, this isn't enforced, but
categories on protocolclass aren't used by the runtime for method lookup.


## Creating a protocolclass

Lets's write a *protocolclass* with everything in it. Let's assume we do need
some internal storage in the protocol. We define this with a 'C' struct
`FooIvars`. 

`Foo.h`:

```objective-c
struct FooIvars 
{
   int   a;
};

@class Foo;
@protocol Foo
- (struct FooIvars *) getFooIvars;
@optional
- (void) doTheFooThing;
@end

@interface Foo <Foo>
@end
```

`Foo.m`:

```
#import "Foo.h"

@implementation Foo 

- (void) doTheFooThing
{
  struct FooIvars   *ivars;
  
  ivars = [self getFooIvars];
  ivars->a += 1848;
}

@end
```

## Using the protocolclass

Using the protocolclass is very simple. You just adopt the protocol.

`MyClass.h`:

```
#import "Foo.h"

@interface MyClass : NSObject < Foo>
{
  struct FooIvars   ivars;
}
@end
```


`MyClass.m`:

```
#import "MyClass.h"

@implementation MyClass 

- (struct FooIvars *) getFooIvars
{
   return( &ivars);
}
@end
```

Now users of your class can call `-doTheFooThing`. Protocolclasses become a time and space saver, if multiple classes
adopt them.

## Things to watch out for

### Reaching the protocolclass via super

In the class adopting your protocol, a call to super will first search the protocolclasses in order
of adoption then the superclass, in this case `NSObject`.

### Calling super from the protocolclass

As a protocolclass is a root class, there is no way to call super from a protocolclass. There is a way 
around this though.

You can search for the overridden implementation of a selector, given the class and category of the
implementation.

```
   IMP   imp;
   
   imp = MulleObjCSearchOverriddenIMP( self, @selector( doTheFooThing), @selector( Foo), 0);
   return( (*imp)( self, @selector( doTheFooThing), self));
```

This works fine, unless the receiver is implementing the same protocolclass again and is calling super.


### Do not use @property in your protocol (yet)

This will create an instance variable in your root class, which taints it.
In the future this will be remedied by:

* use `dynamic` property attribute
* use `propertyclass` keyword 

