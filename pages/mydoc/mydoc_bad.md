---
title: Bad MulleObjC Code
keywords: class
last_updated: March 26, 2019
tags: [language,compiler]
summary: "A non-functional `.m` file that contains all the features that are
absent from MulleObjC."
permalink: mydoc_bad.html
folder: mydoc
---



## Bad Code

These are examples of Objective-C 2.0 code, that will not work with MulleObjC.


### @import

MulleObjC has no support for modules and the **@import** directive. This will
give a compiler error:

```
@import Whatever;             // @import doesn't work
```

See [Porting @property](mydoc_modules.html) for code conversion tips.


### Unsupported @property attributes

The attributes **atomic**,**weak**,**strong**,**nullable**,**unsafe_retained**
**class** are all unknown to MulleObjC and will produce errors:

```
@interface Foo

// unsupported property attribute
@property( atomic) id  a;
@property( weak) id  b;
@property( strong) id  c;
@property( nullable) id  d;      // nullable can be #defined away without trouble
@property( unsafe_unretained) e; // shpuld be no different to assign though
@property( class) id  f;         // class has a chance of being supported sometime

// assign is supported
// we need the next two declarations for @synthesize to complain
@property( assign) id g;
@property( assign) id h;

@end
```

See [Porting @property](mydoc_property.html) for conversion tips.


### @synthesize with different ivar name

You can not synthesize to a different name, ivar must be `'_'<name>`:


```
@implementation Foo

@synthesize g = _g1;

// specfiying a property as dynamic with @dynamic does nothing in MulleObjC
@dynamic h;
```

See [Porting @property](mydoc_synthesize.html) for code conversion tips.


### Subscripting

Subscripting for `NSArray` and `NSDictionary` or any other class is not
supported. Instead the compiler will use C indexing:

```
// subscripting is not supported
- (id) getFirst:(NSArray *) array
{
   return( array[ 0]);
}
```

See [Porting Subscripting](mydoc_subscripting.html) for code conversion tips.


### ARC

ARC code will crash or leak depending on what you are doing:


```
- (id) ARC
{
   return( [[NSArray alloc] init]);
}
```

See [Porting ARC code](mydoc_subscripting.html) for code conversion tips.

### Dot syntax

There is no operator overloading '.' in MulleObjC. '.' is used to accessed
struct and union fields, not objects:

```
// dotsyntax is not supported
- (void) dotsyntax
{
   self.h = @"x";
}

```


See [Porting Dot Syntax](mydoc_dotsyntax.html) for code conversion tips.

### Generics

```
// generics are not supported
- (void) generics:(NSArray<NSString *> *) array
{
}
```

See [Porting Generics](mydoc_generics.html) for code conversion tips.


### Block

```
// blocks are not supported
- (void) blocks:(int (^)(NSString *)) aBlock
{
}
```


See [Porting Blocks](mydoc_blocks.html) for code conversion tips.


### @synchronized,@dynamic

```
// synchronized is not supported
- (void) synchronized
{
   @synchronized( self)
   {
   }
}
```

See [Porting @synchronized](mydoc_synchronized.html) for code conversion tips.


### @YES ...

**@YES** and **@NO** are not supported, use `+numberWithBool:` instead

```
// literal BOOL is not supported
- (NSNumber *) literalBOOL
{
   return( @YES);
}
```

### @()

The literal @() is currently broken and returns `NSDictionary`:

```
- (NSDictionary *) literalAnything
{
   return( @( 32));
}
```

### Protocol *

`Protocol *` as such doesn't exist in MulleObjC. Use PROTOCOL instead:

```
// Protocol * is not supported, use PROTOCOL
- (void) keepProtocol:(Protocol *) proto
{
   [proto retain];  // PROTOCOL is not an object
}
```

See [Porting Protocol](mydoc_protocol.html) for code conversion tips.


### Casting SEL to `(char *)`

In the Apple runtime a SEL is basically a string, but this is not true in
MulleObjC:

```
- (void) printSelectorAsCString:(SEL) sel
{
   printf( "%s\n", sel); // SEL is not a C-String in MulleObjC
}
```

### Accessing variable arguments with va_list

Variable arguments are NOT `va_list` in MulleObjC, but
[mulle-vararg](//github.com/mulle-c/mulle-vararg) instead:

```
- (void) variableArguments:(NSString *) format, ...
{
   va_list   args;

   va_start( args, format);
   va_end( args);
}

@end
```


See [Porting Varargs](mydoc_varargs.html) for code conversion tips.


### @package

**@package** is an unsupported keyword.It will produce a compiler error:

```
@interface NoWorky
@package
@end
```
See [Porting Protocol](mydoc_package.html) for code conversion tips.


## See the output for yourself

Download ([bad-code.m]( {{ site.baseurl}}/files/bad-code.m)) and let the compiler tell you
all about it.


## Next

[Differences](mydoc_differences.html) will list succinctly the differences
between MulleObjC and Objective-C 2.0.
