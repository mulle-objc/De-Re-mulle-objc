---
title: Plug And Play Class
keywords: workflow modern
last_updated: January 23, 2025
tags: [tools modern includes]
summary: ""
permalink: mydoc_pnp_class.html
folder: mydoc
---


A category might need to do a little more to install itself into the
class system, we'll show how in the next example. Here we will be extending
`NSDateFormatter`.

A `NSDateFormatter` has several build-in behaviors that are specified by `NSDateFormatterBehavior10_0` or `NSDateFormatterBehavior10_4`.


We'd like to extend this with a custom behavior `MyDateFormatterBehavior` and
here is how to do it.


## Create a subclass of NSDateFormatter

This will implement the desired behavior. How this is implemented is not
shown. Lets just assume it's a class called `MyDateFormatter`.

``` objc
@interface MyDateFormatter : NSDateFormatter
...
```

## Patch class into NSDateFormatter

NSDateFormatter has an extension mechanism in place called `+mulleSetClass:forFormatterBehavior:`,
where we associate a custom class with the behavior.

We would like to do this ASAP, which is when our custom class gets loaded into
the runtime. `+load` will have to be used, since no one will be calling our
class directly.

The only thing we need to advertise to the user is our new constant value
`MyDateFormatterBehavior` in a header somewhere for the new behavior:

Now comes the bad news, which is: it can be tricky.
The following implementation is correct, but you have to know why.


``` objc
@implementation MyDateFormatter

+ (void) load
{
   [NSDateFormatter mulleSetClass:self
             forFormatterBehavior:MyDateFormatterBehavior];
}

@end
```

As long as you are not using any other Objective-C class except your own class
and its superclasses, your code is safe. But as soon you are using another
class, even just `@"some constant string"` then you have to declare its usage
beforehand. This can be tricky, when class-clusters come into play, where you
may not even know the class (`NSConstantString` in this case for instance).
Even worse, if you are messaging another class, this in turn may message other
classes. And that may be hard to predict and maintain.

Fortunately you can declare a dependency on libraries, which in most cases
should be **Foundation** or some equivalent.

Adding

``` objc
MULLE_OBJC_DEPENDS_ON_LIBRARY( Foundation);
```

before the `+load` method definition will be sufficient in most cases.

> See bla bla for in depth



## Next

Now lets see how a [category](mydoc_pnp_category.html) would support Plug And Play.

