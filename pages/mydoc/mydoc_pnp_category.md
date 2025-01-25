---
title: Plug And Play Category
keywords: workflow modern
last_updated: March 26, 2019
tags: [tools modern includes]
summary: ""
permalink: mydoc_pnp_category.html
folder: mydoc
---

The category is the original plug and play mechanism of Objective-C. With it
you can augment existing classes. Here we do a more complicated kind of
extension, than what you are likely to encounter when dealing categories.


## Extending a class cluster

> See [Class cluster](//developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/ClassCluster.html) for an introduction on
> class clusters.

A class cluster is a class collection of one *placeholder* class and one or
more *concrete* subclasses. The subclasses are not advertised in headers, but
are created by the placeholder and substitute it.

A typical class cluster is `NSString`, to which we will add a subclass now.


### Extend the placeholder class

We will extend `NSString` to natively carry EBCDIC characters.

> It makes technically little sense to do this in a subclass of `NSString`, but
> that's beside the point here.


So we define a category on `NSString` that advertises a new initializer.
The API user will only see this new method, everything else is hidden from
plain sight. The user will still deal only with the familiar `NSString` class:


``` objective-c
#import "import.h"


typedef char   EBCDICChar;


@interface NSString( EBCDIC)

- (instancetype) initWithEBCDICCharacters:(EBCDICChar *) characters
                                   length:(NSUInteger) length;
@end
```


`NSString` is actually a placeholder class. In the implementation of the
category, we instantiate a new EBCDICString and return this. We don't have
to do anything with the placeholder:


``` objective-c
#import "NSString+EBCDIC.h"

#import "import-private.h"

#import "EBCDICString.h"  // import this here and not in import-private


@implementation NSString( EBCDIC)

- (instancetype) initWithEBCDICCharacters:(EBCDICChar *) characters
                                   length:(NSUInteger) length
{
   NSParameterAssert( [self __isClassClusterPlaceholderObject]);

   self = [[EBCDICString alloc] initWithEBCDICCharacters:characters
                                                  length:length];
   return( self);
}

@end
```

> Implementing EBCDICString is left as an exercise to the reader...



## Next

This wraps up the basic developer guide. The [Advanced Programming Guide](https://mulle-objc.github.io/De-Re-mulle-objc/mydoc_overridden.html) leads you into more esoteric territory.
