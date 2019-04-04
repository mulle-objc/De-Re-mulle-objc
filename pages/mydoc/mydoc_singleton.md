---
title: Singleton classes
keywords: class
last_updated: March 26, 2019
tags: [runtime]
summary: ""
permalink: mydoc_singleton.html
folder: mydoc
---

## Create a Singleton class

To create a [singleton class](http://www.galloway.me.uk/tutorials/singleton-classes/) that instantiates
via `+sharedInstance`, you merely adopt the **MulleObjCSingleton** protocol and you are done.

```
@interface Foo : NSObject < MulleObjCSingleton>
@end

@implementation Foo
@end
```

That's because **MulleObjCSingleton** is a [protocolclass](mydoc_protocolclass.html).

If you subclass a singleton class, your subclass should also adopt  **MulleObjCSingleton**. Now your class will create a new
shared instance. Otherwise your subclass would be ignored by `sharedInstance`. Your subclass singleton will now coexist with the base class singleton.

## Modifications

### Change name of the initializer

If you want to use a different name than `+sharedInstance` add this to your class:

```
+ (instancetype) myInit
{
   return( MulleObjCSingletonCreate( self));
}
```

###  Init the singleton differently

Usually the singleton will be allocated with `-init`. You can override `-init` for the singleton instance with `-__initSingleton`.
This can be useful, if you have a not-so-true singleton class like **NSNotificationCenter**, which can instantiate other instances.


### Prevent other instances of the same class

"Poison" the `-init` method by returning the singleton instead. Initialize the singleton with `-__initSingleton`.
As a result you can now expect to be able to use pointer equality for `-isEqual:` comparisons.

```
- (id) init
{
   Class   cls;

   cls = MulleObjCGetClass( self);
   [self release];
   return( [MulleObjCSingletonCreate( cls) retain]);
}

- (id) __initSingleton
{
   return( self);
}
```

## Technical considerations

### Infinitely retained

A singleton is infinitely retained. If you know you are dealing with a singleton, you do not have to retain or release
this. It isn't really recommended to exploit this, as it makes the code more brittle.

### Thread safety

The actual creation of the singleton instance is thread safe, there are no duplicate instances in multiple threads.


### Testing

Usually singletons aren't releases. Under a test environment, the [universe](mydoc_protocolclass.html) will be shutdown
in an orderly fashion and your singleton will be release.

If you want to leak-check within the test though, the singleton will appear as a leak. To circumvent this you can set
the environment variable `MULLE_OBJC_EPHEMERAL_SINGLETON` to YES. The singleton will be now be created in a thread-unsafe
manner and will only last as long as the enclosing **NSAutoreleasePool**.







