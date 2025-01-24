---
title: . syntax for properties
keywords: protocol
last_updated: March 26, 2019
tags: [compiler]
summary: "It's gone"
permalink: mydoc_dotsyntax.html
folder: mydoc
---


Hopefully there will be a code-conversion tool in the future, but for now
translate dot syntax to Objective-C calls.

e.g.

``` objc
- (void) setup
{
   self.propertyA         = 0;
   self.propertyB.numberC = 1;
   self.propertyB.numberD = 2;
}
```

``` objc
- (void) setup
{
   id   propertyB;

   [self setPropertyA:0];

   propertyB = [self propertyB];
   [propertyB setNumberC:1];
   [propertyB setNumberD:2];
}
```

This is also better code.


