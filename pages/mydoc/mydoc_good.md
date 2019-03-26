---
title: Good MulleObjC Code
keywords: class
last_updated: March 26, 2019
tags: [language]
summary: "A functional `.m` file that contains all the features that are
available in MulleObjC."
permalink: mydoc_good.html
folder: mydoc
---


## Good Code

Objective-C is a fairly simple language extension. In this file all available
Objective-C keywords and concepts will be discussed. Absent will be library
features  introduced by the Foundation, because this blows the scope of this
treatise.

The code will be regular Objective-C, unless specifically noted to be an
Objective-C extension.

#### ARC

Please note that ARC is not compatible with MulleObjC.
Use manual `-retain/-release/-autorelease` memory management methods.


### Forward Declaration and Import

You can `#import`  and forward declare code:

```
#import <Foundation/Foundation.h>

// forward declarations of a class and a protocol
@protocol SomeProtocol;
@class Foreign;
```

### Protocol

You can declare a protocol with **@optional**  and **@required** methods and
properties:

```
// declare a protocol with a required (default)
// and an optional method
@protocol MethodProtocol

@required
- (Foreign *) someMethod;

@optional
- (Foreign *) otherMethod;

// properties can be declared in protocols, yet the
// class must redeclare them

@property( assign) NSUInteger  value;

@end
```

You can extend forward declared classes with your protocol, but this is rarely
useful:

```
// extend Foreign class with this method, so
// we know we can message it with that protocol
@class Foreign< MethodProtocol>;
```
### Classes


```
#pragma clang diagnostic ignored "-Wobjc-root-class"
@interface Foo : NSObject < MethodProtocol>
{
@public        // The usual visibility modifiers except `@package`
@protected
@private
   NSUInteger   _value;    // will be used as property "value" ivar
}

// properties and all supported property attributes
@property( readwrite, assign) NSUInteger  value;      // reimplement Protocol
@property( nonatomic, retain) Foreign     *foreign;   // creates own ivar
@property( readonly, nonnull) NSString    *backedByIvar; // creates own ivar

@end
```

The implementation can **@synthesize** a property but it is superflous. The name
of the instance variable is fixed by the compiler to be `'_'<name>`.
`Foo` implements the required method from `MethodProtocol`.

```
@implementation Foo

@synthesize foreign = _foreign;

- (Foreign *) someMethod;
{
   return( _foreign);
}

@end
```

**@defs** is available and great for writing fast accessors, when you don't want
your instance variables to be **@public**:

```
static inline Foreign  *FooGetForeign( Foo *self)
{
   return( ((struct{ @defs( Foo); } *) self)->_foreign);
}


```

#### @compatibility_alias

**@compatibility_alias** will work as expected.

```
// use Foo under alias Foobar
@compatibility_alias Foobar Foo;
```


### Protocolclasses

You can declare [protocolclasses](mydoc_protocolclass.html). This is a
MulleObjC extension to the Objective-C language. This will not work with
other runtimes (though it will compile):

```
// protocolclass Description with default implementation of -description
@class Description;
@protocol Description
- (NSString *) description;

// properties can not be declared in protocolclases yet
// @property( assign) NSUInteger  value;
@end
#pragma clang diagnostic ignored "-Wobjc-root-class"

// protocolclass must implement Protocol of same name
@interface Description< Description>
@end

// implementation will serve the default implementation of description
@implementation Description

- (NSString *) description
{
   return( @"VfL Bochum 1848");
}
@end
```

Your classes can now inherit the description protocol, but it doesn't have to
implement `-description`. It can override it though if desired:

```
@interface Bar : Foo < Description>
@end


@implementation Bar

// call super on protocolclass (not superclass)
- (NSString *) description
{
   return( [super description]);  // unvoidable warning for now
}
```

### Keywords


#### PROTOCOL

**PROTOCOL** is a compiler keyword. Objective-C's `Protocol *` does not work, as
PROTOCOL is a kind of **@selector** in MulleObjC:


```
- (BOOL) knowsThisProtocol:(PROTOCOL) proto
{
   return( @protocol( Description) == proto);
}
```

#### instancetype

**instancetype** behaves normally:


```
// instancetype keyword
- (instancetype) init
{
   return( self);
}
```

#### @encode

**@encode** behaves normally and is 90% compatible with the Apple runtime:

```
// @encode keyword
+ (char *) type
{
   return( @encode( Bar));
}
```

#### @autoreleasepool

You can use **@autoreleasepool**:

```
// keyword autoreleasepool
- (void) autoreleasepool
{
   @autoreleasepool
   {
   }
}
```

#### @try ...

Exception handling can be done with **@try**,**@catch**,**@finally**:

```
- (void) trycatchfinally
{
   @try
   {
   }
   @catch( NSException *e)
   {
   }
   @finally
   {
   }
}
```

#### NS_DURING ...

Or with old-skool  **`NS_DURING`**,**`NS_HANDLER`**,**`NS_ENDHANDLER`**:

```
// exception handling with nsduring
- (void) nsduring
{
NS_DURING
NS_HANDLER
   [localException raise];
NS_ENDHANDLER
}
```

### Literals

Literals are supported *except* **@YES**, **@NO** and **@()**.


#### @1848,@18.48,@'A'

```
- (NSNumber *) literalInteger
{
   return( @1848);
}


- (NSNumber *) literalDouble
{
   return( @18.48);
}


- (NSNumber *) literalCharacter
{
   return( @'A');
}
```

#### @{} and @[]

```
- (NSDictionary *) literalDictionary
{
   return( @{ @"VfL Bochum" : @1848 });
}

- (NSArray *) literalArray
{
   return( @[ @1848, @"VfL Bochum" ]);
}
```

#### @protocol

```
- (PROTOCOL) literalProtocol
{
   return( @protocol( Description));
}
```

#### @selector

```
- (SEL) literalSelector
{
   return( @selector( whatever:));
}
```


### Fast Enumeration

*Fast Enumeration* is supported:

```
// fast enumeration
- (void) fastEnumerate:(NSArray *) array
{
   for( id p in array)
   {
   }
}

@end
```

> Checked against the list of [NSHipster's compiler directive](https://nshipster.com/at-compiler-directives/)

## Putting all the pieces together

Run the `main` function, to verify the truth of what's been written ([good-code.m]({{ site.baseurl}}/files/good-code.m)).


```
int main()
{
   Bar   *bar;

   // don't need an enclosing @autoreleasepool in MulleObjC

   bar = [Bar new];

   [bar fastEnumerate:[NSArray arrayWithObject:@"foo"]];

   NSLog( @"description: %@", [bar description]);
   NSLog( @"literalInteger: %@", [bar literalInteger]);
   NSLog( @"literalDouble: %@", [bar literalDouble]);
   NSLog( @"literalCharacter: %@", [bar literalCharacter]);
   NSLog( @"literalArray: %@", [bar literalArray]);
   NSLog( @"literalDictionary: %@", [bar literalDictionary]);

// NSStringFromProtocol is a 8.0.0 feature
#if MULLE_FOUNDATION_VERSION  >= ((0 << 20) | (15 << 8) | 0)
   NSLog( @"literalProtocol: %@", NSStringFromProtocol( [bar literalProtocol]));
#endif
   NSLog( @"literalSelector: %@", NSStringFromSelector( [bar literalSelector]));

   return( 0);
}
```


### Expected output


```
description: VfL Bochum 1848
literalInteger: 1848
literalDouble: 18.480000
literalCharacter: 65
literalArray: (
    1848,
    VfL Bochum
)
literalDictionary: {
    VfL Bochum = 1848;
}
literalSelector: <invalid selector>
```


## Next

The followup to "good code" is of course [bad code](mydoc_bad.html)
